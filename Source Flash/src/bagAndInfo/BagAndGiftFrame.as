package bagAndInfo
{
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.effect.AlphaShinerAnimation;
   import com.pickgliss.effect.EffectColorType;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PetInfoManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.MainToolBar;
   import ddt.view.tips.OneLineTip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.setTimeout;
   import giftSystem.GiftController;
   import giftSystem.view.GiftView;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   import petsBag.data.PetFarmGuildeTaskType;
   import petsBag.view.item.AddPetItem;
   import road7th.comm.PackageIn;
   import trainer.data.ArrowType;
   import AvatarCollection.view.AvatarCollectionMainView;
   import AvatarCollection.AvatarCollectionManager;
   import trainer.data.Step;
   import totem.TotemManager;
   import totem.view.TotemMainView;
   import ddt.manager.PathManager;
   
   public class BagAndGiftFrame extends Frame
   {
      public static const BAGANDINFO:int = 0;
      
      public static const GIFTVIEW:int = 1;
      
      public static const CARDVIEW:int = 2;
      
      public static const TEXPVIEW:int = 3;
      
      public static const PETVIEW:int = 5;
	  
	  public static const AVATARCOLLECTIONVIEW:int = 6;
	  
	  public static const TOTEMVIEW:int = 8;
      
      private static const PET_OPEN_LEVEL:int = 25;
	  
	  private static const AVATAR_COLLECTION_OPEN_LEVEL:int = 10;
      
      private static var _firstOpenCard:Boolean = true;
      
	  private static const TOTEM_OPEN_LEVEL:int = 20;
      
      private var _infoFrame:BagAndInfoFrame;
      
      private var _giftView:GiftView;
      
      private var _BG:Scale9CornerImage;
      
      private var _btnGroup:SelectedButtonGroup;
      
      private var _infoBtn:SelectedButton;
      
      private var _texpBtn:SelectedButton;
      
      private var _texpBtnTip:OneLineTip;
      
      private var _texpBtnSprite:Sprite;
      
      private var _texpBtnShine:IEffect;
      
      private var _giftBtn:SelectedButton;
      
      private var _giftBtnShine:IEffect;
      
      private var _giftBtnTip:OneLineTip;
      
      private var _giftBtnSprite:Sprite;
      
      private var _petBtn:SelectedButton;
      
      private var _petBtnSprite:Sprite;
      
      private var _petBtnShine:IEffect;
      
      private var _petBtnTip:OneLineTip;
      
      private var _bagType:int = 0;
      
      private var _frame:BaseAlerFrame;
	  
	  private var _avatarCollView:AvatarCollectionMainView;
	  
	  private var _avatarCollBtnShine:IEffect;
	  
	  //private var _avatarCollBtn:SelectedButton;
	  
	  private var _avatarCollBtnSprite:Sprite;
	  
	  private var _avatarCollBtnTip:OneLineTip;
	  
	  private var _totemView:TotemMainView;
	  
	  private var _totemBtn:SelectedButton;
	  
	  private var _totemBtnSprite:Sprite;
	  
	  private var _totemBtnShine:IEffect;
	  
	  private var _totemBtnTip:OneLineTip;
      
      public function BagAndGiftFrame()
      {
         super();
         escEnable = true;
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._infoBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.infoBtn");
         this._texpBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.texpBtn");
         this._giftBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.giftBtn");
         this._petBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.petBtn");
         this._BG = ComponentFactory.Instance.creatComponentByStylename("bagAndInfoFrame.bg");
		 //this._avatarCollBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.avatarCollBtn1");
		 this._totemBtn = ComponentFactory.Instance.creatComponentByStylename("bagAndGiftFrame.totemBtn1");
         addToContent(this._BG);
         addToContent(this._infoBtn);
         addToContent(this._giftBtn);
         addToContent(this._texpBtn);
         addToContent(this._petBtn);
		 //addToContent(this._avatarCollBtn);
		 addToContent(this._totemBtn);
         this._btnGroup = new SelectedButtonGroup();
         this._btnGroup.addSelectItem(this._infoBtn);
         this._btnGroup.addSelectItem(this._giftBtn);
         this._btnGroup.addSelectItem(this._texpBtn);
         this._btnGroup.addSelectItem(this._petBtn);
		 //this._btnGroup.addSelectItem(this._avatarCollBtn);
		 this._btnGroup.addSelectItem(this._totemBtn);
         this._btnGroup.selectIndex = 0;
         this.GiftbtnEnable();
         this.texpBtnEnable();
         this.petBtnEnable();
		 this.totemBtnEnable();
         if(PetBagController.instance().haveTaskOrderByID(PetFarmGuildeTaskType.PET_TASK2))
         {
            PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.OPEN_PET_BAG);
            PetBagController.instance().showPetFarmGuildArrow(ArrowType.OPEN_PET_LABEL,-150,"farmTrainer.openPetLabelArrowPos","asset.farmTrainer.clickHere","farmTrainer.openPetLabelTipPos");
         }
		 if(!PathManager.ToTemEnable)
		 {
			 this._totemBtn.visible = false;
		 }
      }
	  
	  private function totemBtnEnable() : void
	  {
		  var _loc1_:Object = null;
		  if(PlayerManager.Instance.Self.Grade >= TOTEM_OPEN_LEVEL)
		  {
			  this._totemBtn.enable = true;
			  if(this._totemBtnSprite)
			  {
				  ObjectUtils.disposeObject(this._totemBtnSprite);
				  this._totemBtnSprite = null;
			  }
			  if(!GiftController.Instance.inChurch)
			  {
				  _loc1_ = new Object();
				  _loc1_[AlphaShinerAnimation.COLOR] = EffectColorType.GOLD;
				  this._totemBtnShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._totemBtn,_loc1_);
				  this._totemBtnShine.play();
			  }
		  }
		  else
		  {
			  this._totemBtn.enable = false;
			  if(!this._totemBtnSprite)
			  {
				  this._totemBtnSprite = new Sprite();
				  this._totemBtnSprite.addEventListener(MouseEvent.MOUSE_OVER,this.__totemBtnOverHandler);
				  this._totemBtnSprite.addEventListener(MouseEvent.MOUSE_OUT,this.__totemBtnOutHandler);
				  this._totemBtnSprite.graphics.beginFill(0,0);
				  this._totemBtnSprite.graphics.drawRect(0,0,this._totemBtn.displayWidth,this._totemBtn.displayHeight);
				  this._totemBtnSprite.graphics.endFill();
				  this._totemBtnSprite.x = this._totemBtn.x - 1;
				  this._totemBtnSprite.y = this._totemBtn.y + 3;
				  addToContent(this._totemBtnSprite);
				  this._totemBtnTip = new OneLineTip();
				  this._totemBtnTip.tipData = LanguageMgr.GetTranslation("ddt.totemSystem.openTotemBtn.text",TOTEM_OPEN_LEVEL);
				  this._totemBtnTip.visible = false;
			  }
		  }
	  }
      
      public function get btnGroup() : SelectedButtonGroup
      {
         return this._btnGroup;
      }
      
      private function GiftbtnEnable() : void
      {
         var _loc1_:Object = null;
         if(PlayerManager.Instance.Self.Grade >= 16 || GiftController.Instance.inChurch == true)
         {
            this._giftBtn.enable = true;
            if(this._giftBtnSprite)
            {
               ObjectUtils.disposeObject(this._giftBtnSprite);
            }
            this._giftBtnSprite = null;
            if(SharedManager.Instance.giftFirstShow)
            {
               _loc1_ = new Object();
               _loc1_[AlphaShinerAnimation.COLOR] = EffectColorType.GOLD;
               this._giftBtnShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._giftBtn,_loc1_);
               this._giftBtnShine.play();
            }
         }
         else
         {
            this._giftBtn.enable = false;
            if(this._giftBtnSprite == null)
            {
               this._giftBtnSprite = new Sprite();
               this._giftBtnSprite.graphics.beginFill(0,0);
               this._giftBtnSprite.graphics.drawRect(0,0,this._giftBtn.width,this._giftBtn.height);
               this._giftBtnSprite.graphics.endFill();
               this._giftBtnSprite.x = this._giftBtn.x;
               this._giftBtnSprite.y = this._giftBtn.y;
               addToContent(this._giftBtnSprite);
               this._giftBtnTip = new OneLineTip();
               this._giftBtnTip.tipData = LanguageMgr.GetTranslation("ddt.giftSystem.openGiftBtn.text");
               this._giftBtnTip.visible = false;
               this._giftBtnSprite.addEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
               this._giftBtnSprite.addEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
            }
         }
      }
      
      private function texpBtnEnable() : void
      {
         var _loc1_:Object = null;
         if(PlayerManager.Instance.Self.Grade >= 10)
         {
            this._texpBtn.enable = true;
            if(this._texpBtnSprite)
            {
               ObjectUtils.disposeObject(this._texpBtnSprite);
               this._texpBtnSprite = null;
            }
            if(SharedManager.Instance.texpSystemShow && !GiftController.Instance.inChurch)
            {
               _loc1_ = new Object();
               _loc1_[AlphaShinerAnimation.COLOR] = EffectColorType.GOLD;
               this._texpBtnShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._texpBtn,_loc1_);
               this._texpBtnShine.play();
            }
         }
         else
         {
            this._texpBtn.enable = false;
            if(!this._texpBtnSprite)
            {
               this._texpBtnSprite = new Sprite();
               this._texpBtnSprite.addEventListener(MouseEvent.MOUSE_OVER,this.__texpBtnOverHandler);
               this._texpBtnSprite.addEventListener(MouseEvent.MOUSE_OUT,this.__texpBtnOutHandler);
               this._texpBtnSprite.graphics.beginFill(0,0);
               this._texpBtnSprite.graphics.drawRect(0,0,this._texpBtn.width,this._texpBtn.height);
               this._texpBtnSprite.graphics.endFill();
               this._texpBtnSprite.x = this._texpBtn.x;
               this._texpBtnSprite.y = this._texpBtn.y;
               addToContent(this._texpBtnSprite);
               this._texpBtnTip = new OneLineTip();
               this._texpBtnTip.tipData = LanguageMgr.GetTranslation("ddt.texpSystem.openTexpBtn.text");
               this._texpBtnTip.visible = false;
            }
         }
      }
      
      private function petBtnEnable() : void
      {
         if(PlayerManager.Instance.Self.Grade >= PET_OPEN_LEVEL)
         {
            this._petBtn.enable = true;
            if(this._petBtnSprite)
            {
               ObjectUtils.disposeObject(this._petBtnSprite);
               this._petBtnSprite = null;
            }
         }
         else
         {
            this._petBtn.enable = false;
            if(!this._petBtnSprite)
            {
               this._petBtnSprite = new Sprite();
               this._petBtnSprite.addEventListener(MouseEvent.MOUSE_OVER,this.__petBtnOverHandler);
               this._petBtnSprite.addEventListener(MouseEvent.MOUSE_OUT,this.__petBtnOutHandler);
               this._petBtnSprite.graphics.beginFill(0,0);
               this._petBtnSprite.graphics.drawRect(0,0,this._petBtn.displayWidth,this._petBtn.displayHeight);
               this._petBtnSprite.graphics.endFill();
               this._petBtnSprite.x = this._petBtn.x + 38;
               this._petBtnSprite.y = this._petBtn.y + 8;
               addToContent(this._petBtnSprite);
               this._petBtnTip = new OneLineTip();
               this._petBtnTip.tipData = LanguageMgr.GetTranslation("ddt.petSystem.openPetBtn.text");
               this._petBtnTip.visible = false;
            }
         }
      }
      
      private function initEvent() : void
      {
         this._btnGroup.addEventListener(Event.CHANGE,this.__changeHandler);
         this._infoBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._texpBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._giftBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._petBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
		 //this._avatarCollBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
		 this._totemBtn.addEventListener(MouseEvent.CLICK,this.__soundPlay);
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         addEventListener(Event.ADDED_TO_STAGE,this.__getFocus);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ADD_PET,this.__addPet);
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
      }
      
      private function __frameClose(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               this._frame.removeEventListener(FrameEvent.RESPONSE,this.__frameClose);
               SoundManager.instance.play("008");
               (param1.currentTarget as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__frameClose);
               (param1.currentTarget as BaseAlerFrame).dispose();
               SocketManager.Instance.out.sendClearStoreBag();
         }
      }
      
      public function __addPet(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:AddPetItem = null;
         var _loc7_:FilterFrameText = null;
         var _loc8_:AlertInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:Boolean = _loc2_.readBoolean();
         var _loc5_:PetInfo = new PetInfo();
         _loc5_.TemplateID = _loc3_;
         PetInfoManager.fillPetInfo(_loc5_);
         if(_loc5_)
         {
            _loc7_ = ComponentFactory.Instance.creatComponentByStylename("bagandinfo.bagAndInfo.itemOpenUpTxt");
            _loc7_.text = LanguageMgr.GetTranslation("ddt.bagandinfo.bagAndInfo.itemOpenUpTxt");
            this._frame = ComponentFactory.Instance.creatComponentByStylename("bagAndInfo.ItemPreviewListFrame2");
            _loc6_ = ComponentFactory.Instance.creat("bagAndInfo.petAddItem",[_loc5_]);
            _loc8_ = new AlertInfo(_loc5_.Name);
            _loc8_.showCancel = false;
            _loc8_.moveEnable = false;
            this._frame.info = _loc8_;
            this._frame.addToContent(_loc7_);
            this._frame.addToContent(_loc6_);
            this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameClose);
            LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
         this._infoFrame.clearTexpInfo();
      }
      
      private function removeEvent() : void
      {
         if(this._giftBtnSprite)
         {
            this._giftBtnSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.__overHandler);
            this._giftBtnSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.__outHandler);
         }
         if(this._texpBtnSprite)
         {
            this._texpBtnSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.__texpBtnOverHandler);
            this._texpBtnSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.__texpBtnOutHandler);
         }
         if(this._petBtnSprite)
         {
            this._petBtnSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.__petBtnOverHandler);
            this._petBtnSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.__petBtnOutHandler);
         }
		 if(this._totemBtnSprite)
		 {
			 this._totemBtnSprite.removeEventListener(MouseEvent.MOUSE_OVER,this.__totemBtnOverHandler);
			 this._totemBtnSprite.removeEventListener(MouseEvent.MOUSE_OUT,this.__totemBtnOutHandler);
		 }
         this._btnGroup.removeEventListener(Event.CHANGE,this.__changeHandler);
         this._infoBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._texpBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._giftBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         this._petBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
		 //this._avatarCollBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
		 this._totemBtn.removeEventListener(MouseEvent.CLICK,this.__soundPlay);
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         removeEventListener(Event.ADDED_TO_STAGE,this.__getFocus);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ADD_PET,this.__addPet);
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__propertyChange);
      }
      
      protected function __propertyChange(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["Grade"])
         {
            if(PlayerManager.Instance.Self.Grade == 10)
            {
               this.texpBtnEnable();
            }
            if(PlayerManager.Instance.Self.Grade == 16)
            {
               this.GiftbtnEnable();
            }
            if(PlayerManager.Instance.Self.Grade == PET_OPEN_LEVEL)
            {
               this.petBtnEnable();
            }
			if(PlayerManager.Instance.Self.Grade == TOTEM_OPEN_LEVEL)
			{
				this.totemBtnEnable();
			}
         }
      }
      
      private function __soundPlay(param1:MouseEvent) : void
      {
         PlayerInfoViewControl.isOpenFromBag = true;
         SoundManager.instance.play("008");
         if((param1.target as SelectedButton).selectedStyle == "asset.infoBtn2")
         {
            this.showInfoFrame(BAGANDINFO);
         }
      }
      
      private function __overHandler(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         this._giftBtnTip.visible = true;
         LayerManager.Instance.addToLayer(this._giftBtnTip,LayerManager.GAME_TOP_LAYER);
         _loc2_ = this._giftBtn.localToGlobal(new Point(0,0));
         this._giftBtnTip.x = _loc2_.x;
         this._giftBtnTip.y = _loc2_.y + this._giftBtn.height;
      }
      
      private function __outHandler(param1:MouseEvent) : void
      {
         this._giftBtnTip.visible = false;
      }
      
      private function __texpBtnOverHandler(param1:MouseEvent) : void
      {
         this._texpBtnTip.visible = true;
         LayerManager.Instance.addToLayer(this._texpBtnTip,LayerManager.GAME_TOP_LAYER);
         var _loc2_:Point = this._texpBtn.localToGlobal(new Point(0,0));
         this._texpBtnTip.x = _loc2_.x;
         this._texpBtnTip.y = _loc2_.y + this._texpBtn.height;
      }
      
      private function __texpBtnOutHandler(param1:MouseEvent) : void
      {
         this._texpBtnTip.visible = false;
      }
      
      private function __petBtnOverHandler(param1:MouseEvent) : void
      {
         this._petBtnTip.visible = true;
         LayerManager.Instance.addToLayer(this._petBtnTip,LayerManager.GAME_TOP_LAYER);
         var _loc2_:Point = this._petBtn.localToGlobal(new Point(0,0));
         this._petBtnTip.x = _loc2_.x;
         this._petBtnTip.y = _loc2_.y + this._petBtn.height + 5;
      }
      
      private function __petBtnOutHandler(param1:MouseEvent) : void
      {
         this._petBtnTip.visible = false;
      }
      
      private function __changeHandler(param1:Event) : void
      {
         if(this._infoFrame)
         {
            this._infoFrame.clearTexpInfo();
         }
         switch(this._btnGroup.selectIndex)
         {
            case BAGANDINFO:
               this.showInfoFrame(BAGANDINFO);
               break;
            case GIFTVIEW:
               this.showGiftFrame();
               break;
            case 2:
               this.showInfoFrame(TEXPVIEW);
               break;
            case 3:
               this.showInfoFrame(PETVIEW);
			   break;
			case 5:
				this.showAvatarCollection();
				break;
			case 4:
				this.showTotem();
				break;
         }
      }
      
      private function setVisible(param1:int) : void
      {
         if(this._infoFrame)
         {
            this._infoFrame.visible = param1 == BAGANDINFO ? Boolean(Boolean(true)) : Boolean(Boolean(false));
         }
         if(this._giftView)
         {
            this._giftView.visible = param1 == GIFTVIEW ? Boolean(Boolean(true)) : Boolean(Boolean(false));
         }
		 if(this._avatarCollView)
		 {
			 this._avatarCollView.visible = param1 == AVATARCOLLECTIONVIEW?Boolean(true):Boolean(false);
		 }
		 if(this._totemView)
		 {
			 this._totemView.visible = param1 == TOTEMVIEW ? Boolean(Boolean(true)) : Boolean(Boolean(false));
		 }
      }
	  
	  private function showTotem() : void
	  {
		  if(this._totemBtnShine)
		  {
			  this._totemBtnShine.stop();
			  SocketManager.Instance.out.syncWeakStep(102);
		  }
		  if(!this._totemView)
		  {
			  TotemManager.instance.loadTotemModule(this.doShowTotem);
		  }
		  else
		  {
			  this.setVisible(TOTEMVIEW);
		  }
	  }
	  
	  private function doShowTotem() : void
	  {
		  this._totemView = ComponentFactory.Instance.creatCustomObject("totemView");
		  addToContent(this._totemView);
		  this.setVisible(TOTEMVIEW);
	  }
      
      private function showGiftFrame() : void
      {
         if(this._giftBtnShine)
         {
            this._giftBtnShine.stop();
            SharedManager.Instance.giftFirstShow = false;
            SharedManager.Instance.save();
         }
         if(this._giftView == null)
         {
            try
            {
               this._giftView = ComponentFactory.Instance.creatCustomObject("giftView");
               addToContent(this._giftView);
            }
            catch(e:Error)
            {
               UIModuleLoader.Instance.addUIModlue(UIModuleTypes.GIFT_SYSTEM);
               UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,__createGift);
               return;
            }
         }
         GiftController.Instance.canActive = true;
         SocketManager.Instance.out.sendUpdateGoodsCount();
         this._giftView.info = PlayerManager.Instance.Self;
         this.setVisible(GIFTVIEW);
      }
      
      private function __createGift(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.GIFT_SYSTEM)
         {
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__createGift);
            this.showGiftFrame();
         }
      }
      
      private function showInfoFrame(param1:int) : void
      {
         if(param1 == TEXPVIEW && this._texpBtnShine)
         {
            this._texpBtnShine.stop();
            SharedManager.Instance.texpSystemShow = false;
            SharedManager.Instance.save();
         }
         if(this._infoFrame == null)
         {
            this._infoFrame = ComponentFactory.Instance.creatCustomObject("bagAndInfoFrame");
            addToContent(this._infoFrame);
         }
         if(param1 == PETVIEW)
         {
            this._infoFrame.isScreenFood = true;
         }
         else
         {
            this._infoFrame.isScreenFood = false;
         }
         this._infoFrame.switchShow(param1);
         this.setVisible(BAGANDINFO);
      }
      
      private function __getFocus(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.__getFocus);
         StageReferance.stage.focus = this;
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
            if(PlayerManager.Instance.Self.Grade == 3)
            {
               MainToolBar.Instance.tipTask();
            }
         }
      }
      
      public function show(param1:int, param2:String = "") : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._btnGroup.selectIndex = param1;
         if(GiftController.Instance.inChurch == true)
         {
            this._infoBtn.enable = false;
            this._texpBtn.enable = false;
            this._petBtn.enable = false;
			//this._avatarCollBtn.enable = false;
			this._totemBtn.enable = false;
         }
         if(param1 == GIFTVIEW && param2 != "")
         {
            setTimeout(GiftController.Instance.RebackClick,300,param2);
         }
         this.__changeHandler(null);
      }
	  
	  private function doShowAvatarCollection() : void
	  {
		  this._avatarCollView = new AvatarCollectionMainView();
		  addToContent(this._avatarCollView);
		  this.setVisible(AVATARCOLLECTIONVIEW);
	  }
	  
	  private function showAvatarCollection() : void
	  {
		  if(this._avatarCollBtnShine)
		  {
			  this._avatarCollBtnShine.stop();
			  SocketManager.Instance.out.syncWeakStep(Step.AVATAR_COLLECTION_OPEN_SHINE);
		  }
		  if(!this._avatarCollView)
		  {
			  AvatarCollectionManager.instance.loadResModule(this.doShowAvatarCollection);
		  }
		  else
		  {
			  this.setVisible(AVATARCOLLECTIONVIEW);
		  }
	  }
	  
	  private function avatarCollBtnEnable() : void
	  {
		  var _loc1_:Object = null;
		  if(PlayerManager.Instance.Self.Grade >= AVATAR_COLLECTION_OPEN_LEVEL)
		  {
			  //this._avatarCollBtn.enable = true;
			  if(this._avatarCollBtnSprite)
			  {
				  ObjectUtils.disposeObject(this._avatarCollBtnSprite);
				  this._avatarCollBtnSprite = null;
			  }
			  if(!PlayerManager.Instance.Self.isNewOnceFinish(Step.AVATAR_COLLECTION_OPEN_SHINE) && !GiftController.Instance.inChurch)
			  {
				  _loc1_ = new Object();
				  _loc1_[AlphaShinerAnimation.COLOR] = EffectColorType.GOLD;
				  //this._avatarCollBtnShine = EffectManager.Instance.creatEffect(EffectTypes.ALPHA_SHINER_ANIMATION,this._avatarCollBtn,_loc1_);
				  this._avatarCollBtnShine.play();
			  }
		  }
		  else
		  {
			  //this._avatarCollBtn.enable = false;
			  if(!this._avatarCollBtnSprite)
			  {
				  this._avatarCollBtnSprite = new Sprite();
				  this._avatarCollBtnSprite.addEventListener(MouseEvent.MOUSE_OVER,this.__avatarCollBtnOverHandler);
				  this._avatarCollBtnSprite.addEventListener(MouseEvent.MOUSE_OUT,this.__avatarCollBtnOutHandler);
				  this._avatarCollBtnSprite.graphics.beginFill(0,0);
				  //this._avatarCollBtnSprite.graphics.drawRect(0,0,this._avatarCollBtn.displayWidth,this._avatarCollBtn.displayHeight);
				  this._avatarCollBtnSprite.graphics.endFill();
				  //this._avatarCollBtnSprite.x = this._avatarCollBtn.x - 1;
				  //this._avatarCollBtnSprite.y = this._avatarCollBtn.y + 3;
				  addToContent(this._avatarCollBtnSprite);
				  this._avatarCollBtnTip = new OneLineTip();
				  this._avatarCollBtnTip.tipData = LanguageMgr.GetTranslation("ddt.avatarCollSystem.openAvatarCollBtn.text",AVATAR_COLLECTION_OPEN_LEVEL);
				  this._avatarCollBtnTip.visible = false;
			  }
		  }
	  }
	  
	  private function __avatarCollBtnOverHandler(param1:MouseEvent) : void
	  {
		  var loc2:Point = null;
		  this._avatarCollBtnTip.visible = true;
		  LayerManager.Instance.addToLayer(this._avatarCollBtnTip,LayerManager.GAME_TOP_LAYER);
		  //loc2 = this._avatarCollBtn.localToGlobal(new Point(0,0));
		  this._avatarCollBtnTip.x = loc2.x - 9;
		  //this._avatarCollBtnTip.y = loc2.y + this._avatarCollBtn.height;
	  }
	  
	  private function __avatarCollBtnOutHandler(param1:MouseEvent) : void
	  {
		  this._avatarCollBtnTip.visible = false;
	  }
	  
	  private function __totemBtnOverHandler(param1:MouseEvent) : void
	  {
		  this._totemBtnTip.visible = true;
		  LayerManager.Instance.addToLayer(this._totemBtnTip,LayerManager.GAME_TOP_LAYER);
		  var _loc2_:Point = this._totemBtn.localToGlobal(new Point(0,0));
		  this._totemBtnTip.x = _loc2_.x - 9;
		  this._totemBtnTip.y = _loc2_.y + this._totemBtn.height;
	  }
	  
	  private function __totemBtnOutHandler(param1:MouseEvent) : void
	  {
		  this._totemBtnTip.visible = false;
	  }
      
      override public function dispose() : void
      {
         if(this._giftBtnShine)
         {
            EffectManager.Instance.removeEffect(this._giftBtnShine);
         }
         this._giftBtnShine = null;
         if(this._texpBtnShine)
         {
            EffectManager.Instance.removeEffect(this._texpBtnShine);
         }
         this._texpBtnShine = null;
         BagAndInfoManager.Instance.clearReference();
         this.removeEvent();
         if(this._petBtn)
         {
            ObjectUtils.disposeObject(this._petBtn);
            this._petBtn = null;
         }
         if(this._frame)
         {
            this._frame.removeEventListener(FrameEvent.RESPONSE,this.__frameClose);
            this._frame.dispose();
            this._frame = null;
         }
         if(this._infoBtn)
         {
            ObjectUtils.disposeObject(this._infoBtn);
         }
         this._infoBtn = null;
         if(this._texpBtn)
         {
            ObjectUtils.disposeObject(this._texpBtn);
         }
         this._texpBtn = null;
         if(this._texpBtnTip)
         {
            ObjectUtils.disposeObject(this._texpBtnTip);
         }
         this._texpBtnTip = null;
         if(this._texpBtnSprite)
         {
            ObjectUtils.disposeObject(this._texpBtnSprite);
         }
         this._texpBtnSprite = null;
         if(this._giftBtn)
         {
            ObjectUtils.disposeObject(this._giftBtn);
         }
         this._giftBtn = null;
         if(this._BG)
         {
            ObjectUtils.disposeObject(this._BG);
         }
         this._BG = null;
         if(this._giftBtnSprite)
         {
            ObjectUtils.disposeObject(this._giftBtnSprite);
         }
         this._giftBtnSprite = null;
         if(this._giftBtnTip)
         {
            ObjectUtils.disposeObject(this._giftBtnTip);
         }
         this._giftBtnTip = null;
         if(this._petBtnTip)
         {
            ObjectUtils.disposeObject(this._petBtnTip);
         }
         this._petBtnTip = null;
         if(this._infoFrame)
         {
            this._infoFrame.dispose();
         }
         this._infoFrame = null;
         if(this._giftView)
         {
            this._giftView.dispose();
         }
         this._giftView = null;
         PetBagController.instance().clearCurrentPetFarmGuildeArrow(ArrowType.OPEN_PET_LABEL);
		 //if(this._avatarCollBtn)
		 //{
		//	 ObjectUtils.disposeObject(this._avatarCollBtn);
		 //}
		 //this._avatarCollBtn = null;
		 if(this._totemBtnShine)
		 {
			 EffectManager.Instance.removeEffect(this._totemBtnShine);
		 }
		 this._totemBtnShine = null;
		 if(this._totemBtnSprite)
		 {
			 ObjectUtils.disposeObject(this._totemBtnSprite);
		 }
		 this._totemBtnSprite = null;
		 if(this._totemBtnTip)
		 {
			 ObjectUtils.disposeObject(this._totemBtnTip);
		 }
		 this._totemBtnTip = null;
		 if(this._totemBtn)
		 {
			 ObjectUtils.disposeObject(this._totemBtn);
		 }
		 this._totemBtn = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
         super.dispose();
      }
   }
}
