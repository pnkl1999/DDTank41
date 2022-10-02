package farm.viewx.helper
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.data.ShopType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import farm.FarmModelController;
   import farm.view.compose.event.SelectComposeItemEvent;
   import farm.viewx.shop.FarmShopView;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import shop.view.ShopItemCell;
   
   public class HelperSetView extends Frame
   {
      
      private static const MaxNum:int = 50;
       
      
      private var _titleBg:Bitmap;
      
      private var _titleTxt:FilterFrameText;
      
      private var _btmBg:ScaleBitmapImage;
      
      private var _ResetBtn:TextButton;
      
      private var _okBtn:TextButton;
      
      private var _Bg:ScaleBitmapImage;
      
      private var _SetBg:Scale9CornerImage;
      
      private var _SetBg1:Scale9CornerImage;
      
      private var _AddBtn:BaseButton;
      
      private var _AddBtn1:BaseButton;
      
      private var _MinusBtn:BaseButton;
      
      private var _MinusBtn1:BaseButton;
      
      private var _SetInputBg:Scale9CornerImage;
      
      private var _SetInputBg1:Scale9CornerImage;
      
      private var _setNumTxt:TextInput;
      
      private var _setNumTxt1:TextInput;
      
      private var _setNum:int = 0;
      
      private var _setFertilizerNum:int = 0;
      
      private var _NumerTxt:FilterFrameText;
      
      private var _NumerTxt1:FilterFrameText;
      
      private var _seedBtn:BaseButton;
      
      private var _FertilizerBtn:BaseButton;
      
      private var _seedSetBg:Bitmap;
      
      private var _fertilizerSetBg:Bitmap;
      
      private var _seedList:SeedSelect;
      
      private var _fertilizerList:FertilizerSelect;
      
      private var _result:ShopItemCell;
      
      private var _fertiliresult:ShopItemCell;
      
      private var _helperSetViewSelectResult:Function;
      
      private var _buyFrame:HelperBuyAlertFrame;
      
      private var seednum:int;
      
      private var manure:int;
      
      private var _farmShop:FarmShopView;
      
      private var _findNumState:Function;
      
      public function HelperSetView()
      {
         super();
         this.initView();
         this.addEvent();
         escEnable = true;
      }
      
      private function initView() : void
      {
         this._titleBg = ComponentFactory.Instance.creatBitmap("assets.farm.titleSmall");
         addToContent(this._titleBg);
         PositionUtils.setPos(this._titleBg,"farm.helperSettilte.Pos");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("farm.text.farmShopPayPnlTitle");
         this._titleTxt.text = LanguageMgr.GetTranslation("ddt.farm.hepper.help.Set");
         addToContent(this._titleTxt);
         PositionUtils.setPos(this._titleTxt,"farm.helperSettilteTxt.Pos");
         this._btmBg = ComponentFactory.Instance.creatComponentByStylename("asset.farmheler.btmBimap");
         addToContent(this._btmBg);
         this._ResetBtn = ComponentFactory.Instance.creatComponentByStylename("farm.helper.ResetBtn");
         this._ResetBtn.text = LanguageMgr.GetTranslation("ddt.farm.hepper.help.Reset");
         addToContent(this._ResetBtn);
         this._okBtn = ComponentFactory.Instance.creatComponentByStylename("farm.helper.okBtn");
         this._okBtn.text = LanguageMgr.GetTranslation("shop.PresentFrame.OkBtnText");
         addToContent(this._okBtn);
         this._Bg = ComponentFactory.Instance.creatComponentByStylename("asset.HelperSet.bg");
         addToContent(this._Bg);
         this._SetBg = ComponentFactory.Instance.creatComponentByStylename("asset.HelperSet.bgI");
         addToContent(this._SetBg);
         this._SetBg1 = ComponentFactory.Instance.creatComponentByStylename("asset.HelperSet.bgII");
         addToContent(this._SetBg1);
         this._AddBtn = ComponentFactory.Instance.creatComponentByStylename("helperSet.NumberAddBtn");
         addToContent(this._AddBtn);
         this._AddBtn1 = ComponentFactory.Instance.creatComponentByStylename("helperSet.NumberAddBtn");
         addToContent(this._AddBtn1);
         PositionUtils.setPos(this._AddBtn1,"farm.helperSetAddbtn.Pos");
         this._MinusBtn = ComponentFactory.Instance.creatComponentByStylename("helperSet.NumberMinuesBtn");
         addToContent(this._MinusBtn);
         this._MinusBtn1 = ComponentFactory.Instance.creatComponentByStylename("helperSet.NumberMinuesBtn");
         addToContent(this._MinusBtn1);
         PositionUtils.setPos(this._MinusBtn1,"farm.helperSetMinues.Pos");
         this._SetInputBg = ComponentFactory.Instance.creatComponentByStylename("farm.helper.SetInputBg");
         addToContent(this._SetInputBg);
         this._SetInputBg1 = ComponentFactory.Instance.creatComponentByStylename("farm.helper.SetInputBg");
         addToContent(this._SetInputBg1);
         PositionUtils.setPos(this._SetInputBg1,"farm.helper.SetInputBg.Pos");
         this._setNumTxt = ComponentFactory.Instance.creatComponentByStylename("farm.text.SetNumInput");
         addToContent(this._setNumTxt);
         this._setNumTxt.textField.restrict = "0-9";
         this._setNumTxt1 = ComponentFactory.Instance.creatComponentByStylename("farm.text.SetNumInput");
         addToContent(this._setNumTxt1);
         PositionUtils.setPos(this._setNumTxt1,"farm.helper.SetInputTxt.Pos");
         this._setNumTxt1.textField.restrict = "0-9";
         this._setNum = 0;
         this._setFertilizerNum = 0;
         this._NumerTxt = ComponentFactory.Instance.creatComponentByStylename("farm.text.NumText");
         this._NumerTxt1 = ComponentFactory.Instance.creatComponentByStylename("farm.text.NumText");
         this._NumerTxt.text = this._NumerTxt1.text = LanguageMgr.GetTranslation("tank.view.bagII.BreakGoodsView.num");
         PositionUtils.setPos(this._NumerTxt1,"farm.helper.NumberTxt.Pos");
         addToContent(this._NumerTxt);
         addToContent(this._NumerTxt1);
         this._seedBtn = ComponentFactory.Instance.creatComponentByStylename("helperSet.SeedBtn");
         addToContent(this._seedBtn);
         this._FertilizerBtn = ComponentFactory.Instance.creatComponentByStylename("helperSet.FertilizerBtn");
         addToContent(this._FertilizerBtn);
         this._seedSetBg = ComponentFactory.Instance.creatBitmap("asset.farmHelper.SetBg1");
         this._fertilizerSetBg = ComponentFactory.Instance.creatBitmap("asset.farmHelper.SetBg");
         this._seedList = new SeedSelect();
         this._fertilizerList = new FertilizerSelect();
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,50,50);
         _loc1_.graphics.endFill();
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.beginFill(16777215,0);
         _loc2_.graphics.drawRect(0,0,50,50);
         _loc2_.graphics.endFill();
         this._result = new ShopItemCell(_loc1_,null,false,true);
         this._result.cellSize = 50;
         PositionUtils.setPos(this._result,"farm.helper.cellPos");
         this._seedBtn.addChild(this._result);
         this._seedBtn.mouseChildren = true;
         this._fertiliresult = new ShopItemCell(_loc2_);
         this._fertiliresult.cellSize = 50;
         PositionUtils.setPos(this._fertiliresult,"farm.helper.cellPos");
         this._FertilizerBtn.addChild(this._fertiliresult);
         this._FertilizerBtn.mouseChildren = true;
      }
      
      public function set helperSetViewSelectResult(param1:Function) : void
      {
         this._helperSetViewSelectResult = param1;
      }
      
      public function update(param1:FilterFrameText, param2:FilterFrameText, param3:FilterFrameText, param4:FilterFrameText) : void
      {
         var _loc13_:ShopItemInfo = null;
         var _loc14_:ShopItemInfo = null;
         var _loc5_:Vector.<ShopItemInfo> = ShopManager.Instance.getValidGoodByType(ShopType.FARM_SEED_TYPE);
         var _loc6_:Dictionary = new Dictionary();
         var _loc7_:Dictionary = new Dictionary();
         var _loc8_:int = 0;
         while(_loc8_ < _loc5_.length)
         {
            _loc13_ = _loc5_[_loc8_];
            _loc6_[_loc13_.TemplateInfo.Name] = _loc13_.TemplateInfo.TemplateID;
            _loc8_++;
         }
         var _loc9_:Vector.<ShopItemInfo> = ShopManager.Instance.getValidGoodByType(ShopType.FARM_MANURE_TYPE);
         var _loc10_:int = 0;
         while(_loc10_ < _loc9_.length)
         {
            _loc14_ = _loc9_[_loc10_];
            _loc7_[_loc14_.TemplateInfo.Name] = _loc14_.TemplateInfo.TemplateID;
            _loc10_++;
         }
         var _loc11_:int = _loc6_[param1.text];
         var _loc12_:int = _loc7_[param3.text];
         this._result.info = ItemManager.Instance.getTemplateById(_loc11_);
         this._fertiliresult.info = ItemManager.Instance.getTemplateById(_loc12_);
         if(this._result.info == null)
         {
            this._AddBtn.enable = false;
            this._MinusBtn.enable = false;
         }
         else
         {
            this._AddBtn.enable = true;
            this._MinusBtn.enable = true;
         }
         if(this._fertiliresult.info == null)
         {
            this._AddBtn1.enable = false;
            this._MinusBtn1.enable = false;
         }
         else
         {
            this._AddBtn1.enable = true;
            this._MinusBtn1.enable = true;
         }
         this._setNumTxt.text = param2.text;
         this._setNum = int(param2.text);
         this._setNumTxt1.text = param4.text;
         this._setFertilizerNum = int(param4.text);
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameHandler);
         this._AddBtn.addEventListener(MouseEvent.CLICK,this.__selectNum);
         this._AddBtn1.addEventListener(MouseEvent.CLICK,this.__selectNum);
         this._MinusBtn.addEventListener(MouseEvent.CLICK,this.__selectNum);
         this._MinusBtn1.addEventListener(MouseEvent.CLICK,this.__selectNum);
         this._setNumTxt.addEventListener(Event.CHANGE,this.__txtchange);
         this._setNumTxt1.addEventListener(Event.CHANGE,this.__txtchange1);
         this._okBtn.addEventListener(MouseEvent.CLICK,this.__okHandler);
         this._ResetBtn.addEventListener(MouseEvent.CLICK,this.__resetHandler);
         this._seedBtn.addEventListener(MouseEvent.CLICK,this.__seedHandler);
         this._FertilizerBtn.addEventListener(MouseEvent.CLICK,this.__fertiliHandler);
         this._seedList.addEventListener(SelectComposeItemEvent.SELECT_SEED,this.__setseed);
         this._fertilizerList.addEventListener(SelectComposeItemEvent.SELECT_FERTILIZER,this.__setfertilizer);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameHandler);
         this._AddBtn.removeEventListener(MouseEvent.CLICK,this.__selectNum);
         this._AddBtn1.removeEventListener(MouseEvent.CLICK,this.__selectNum);
         this._MinusBtn.removeEventListener(MouseEvent.CLICK,this.__selectNum);
         this._MinusBtn1.removeEventListener(MouseEvent.CLICK,this.__selectNum);
         this._setNumTxt.removeEventListener(Event.CHANGE,this.__txtchange);
         this._setNumTxt1.removeEventListener(Event.CHANGE,this.__txtchange1);
         this._ResetBtn.removeEventListener(MouseEvent.CLICK,this.__resetHandler);
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.__okHandler);
         this._seedBtn.removeEventListener(MouseEvent.CLICK,this.__seedHandler);
         this._FertilizerBtn.removeEventListener(MouseEvent.CLICK,this.__fertiliHandler);
         this._seedList.removeEventListener(SelectComposeItemEvent.SELECT_SEED,this.__setseed);
         this._fertilizerList.removeEventListener(SelectComposeItemEvent.SELECT_FERTILIZER,this.__setfertilizer);
      }
      
      private function __txtchange(param1:Event) : void
      {
         this._setNum = parseInt(this._setNumTxt.text);
         this.checkInput();
      }
      
      private function __txtchange1(param1:Event) : void
      {
         this._setFertilizerNum = parseInt(this._setNumTxt1.text);
         this.checkInputOne();
      }
      
      private function __selectNum(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._AddBtn:
               ++this._setNum;
               this.checkInput();
               break;
            case this._AddBtn1:
               ++this._setFertilizerNum;
               this.checkInputOne();
               break;
            case this._MinusBtn:
               if(this._setNum < 1)
               {
                  this._setNum == 1;
               }
               else
               {
                  --this._setNum;
               }
               this.checkInput();
               break;
            case this._MinusBtn1:
               if(this._setFertilizerNum < 1)
               {
                  this._setFertilizerNum == 1;
               }
               else
               {
                  --this._setFertilizerNum;
               }
               this.checkInputOne();
         }
      }
      
      private function __resetHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._setNumTxt.text = "0";
         this._setNumTxt1.text = "0";
         this._setNum = 0;
         this._setFertilizerNum = 0;
         if(this._result.info)
         {
            this._result.info = ItemManager.Instance.getTemplateById(0);
         }
         if(this._fertiliresult.info)
         {
            this._fertiliresult.info = ItemManager.Instance.getTemplateById(0);
         }
         this._AddBtn.enable = false;
         this._AddBtn1.enable = false;
         this._MinusBtn.enable = false;
         this._MinusBtn1.enable = false;
      }
      
      private function __okHandler(param1:MouseEvent) : void
      {
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         SoundManager.instance.play("008");
         this.seednum = int(this._setNumTxt.text);
         this.manure = int(this._setNumTxt1.text);
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:InventoryItemInfo = null;
         if(this._result.info)
         {
            _loc4_ = FarmModelController.instance.model.findItemInfo(EquipType.SEED,this._result.info.TemplateID);
         }
         if(this._fertiliresult.info)
         {
            _loc5_ = FarmModelController.instance.model.findItemInfo(EquipType.MANURE,this._fertiliresult.info.TemplateID);
         }
         if(_loc4_)
         {
            if(_loc4_.CategoryID == EquipType.SEED && _loc4_.Count < this.seednum)
            {
               this.buyAlert();
               return;
            }
            if(this.seednum == 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.helper.SetTxt3"));
               return;
            }
         }
         if(_loc4_ == null && this.seednum > 0)
         {
            this.buyAlert();
            return;
         }
         if(_loc5_ == null && this.manure > 0)
         {
            this.buyAlert();
            return;
         }
         if(_loc5_)
         {
            if(_loc5_.CategoryID == EquipType.MANURE && _loc5_.Count < this.manure)
            {
               this.buyAlert();
               return;
            }
            if(this.manure == 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.helper.SetTxt4"));
               return;
            }
         }
         var _loc6_:Object = new Object();
         if(this._result.info)
         {
            _loc2_ = true;
            _loc6_.seedId = this._result.info.TemplateID;
            _loc6_.seedNum = this.seednum;
         }
         if(this._fertiliresult.info)
         {
            _loc3_ = true;
            _loc6_.manureId = this._fertiliresult.info.TemplateID;
            _loc6_.manureNum = this.manure;
         }
         _loc6_.isSeed = _loc2_;
         _loc6_.isManure = _loc3_;
         if(this._findNumState != null)
         {
            _loc7_ = _loc6_.seedId;
            if(!_loc7_)
            {
               _loc7_ = 0;
            }
            _loc8_ = _loc6_.manureId;
            if(!_loc8_)
            {
               _loc8_ = 0;
            }
            if(this._findNumState.call(this,_loc7_,_loc8_) > 0)
            {
               this.buyAlert();
               return;
            }
         }
         if(this._helperSetViewSelectResult != null)
         {
            this._helperSetViewSelectResult.call(this,_loc6_);
         }
         this.dispose();
      }
      
      private function buyAlert() : void
      {
         this._buyFrame = ComponentFactory.Instance.creatComponentByStylename("farm.HelperBuyAlertFrame.confirmBuy");
         LayerManager.Instance.addToLayer(this._buyFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this._buyFrame.addEventListener(FrameEvent.RESPONSE,this.__onBuyResponse);
      }
      
      private function __onBuyResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._buyFrame.removeEventListener(FrameEvent.RESPONSE,this.__onBuyResponse);
         this._buyFrame.dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this._farmShop = ComponentFactory.Instance.creatComponentByStylename("farm.farmShopView.shop");
            this._farmShop.addEventListener(FrameEvent.RESPONSE,this.__closeFarmShop);
            this._farmShop.show();
            this._buyFrame.dispose();
         }
      }
      
      private function __closeFarmShop(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._farmShop.removeEventListener(FrameEvent.RESPONSE,this.__closeFarmShop);
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               ObjectUtils.disposeObject(this._farmShop);
               this._farmShop = null;
         }
      }
      
      public function get getTxtNum1() : int
      {
         return this.seednum;
      }
      
      public function get getTxtNum2() : int
      {
         return this.manure;
      }
      
      public function get getTxtId1() : int
      {
         var _loc1_:int = 0;
         if(this._result && this._result.info)
         {
            _loc1_ = this._result.info.TemplateID;
         }
         return _loc1_;
      }
      
      public function get getTxtId2() : int
      {
         var _loc1_:int = 0;
         if(this._fertiliresult && this._fertiliresult.info)
         {
            _loc1_ = this._fertiliresult.info.TemplateID;
         }
         return _loc1_;
      }
      
      private function checkInput() : void
      {
         if(this._setNum < 1)
         {
            this._setNum = 0;
         }
         else if(this._setNum > MaxNum)
         {
            this._setNum = MaxNum;
         }
         this._setNumTxt.text = this._setNum.toString();
      }
      
      private function checkInputOne() : void
      {
         if(this._setFertilizerNum < 1)
         {
            this._setFertilizerNum = 0;
         }
         else if(this._setFertilizerNum > MaxNum)
         {
            this._setFertilizerNum = MaxNum;
         }
         this._setNumTxt1.text = this._setFertilizerNum.toString();
      }
      
      private function __frameHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      private function __seedHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:Point = this._seedBtn.localToGlobal(new Point(-100,-60));
         this._seedList.x = _loc2_.x;
         this._seedList.y = _loc2_.y;
         this._seedList.setVisible = true;
      }
      
      private function __fertiliHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:Point = this._FertilizerBtn.localToGlobal(new Point(-100,60));
         this._fertilizerList.x = _loc2_.x;
         this._fertilizerList.y = _loc2_.y;
         this._fertilizerList.setVisible = true;
      }
      
      private function __setseed(param1:SelectComposeItemEvent) : void
      {
         var _loc2_:int = int(param1.data.id);
         this._result.info = ItemManager.Instance.getTemplateById(_loc2_);
         this._AddBtn.enable = true;
         this._MinusBtn.enable = true;
      }
      
      private function __setfertilizer(param1:SelectComposeItemEvent) : void
      {
         var _loc2_:int = int(param1.data.id);
         this._fertiliresult.info = ItemManager.Instance.getTemplateById(_loc2_);
         this._AddBtn1.enable = true;
         this._MinusBtn1.enable = true;
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function set findNumState(param1:Function) : void
      {
         this._findNumState = param1;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(this._titleBg)
         {
            ObjectUtils.disposeObject(this._titleBg);
            this._titleBg = null;
         }
         if(this._SetBg)
         {
            ObjectUtils.disposeObject(this._SetBg);
            this._SetBg = null;
         }
         if(this._SetBg1)
         {
            ObjectUtils.disposeObject(this._SetBg1);
            this._SetBg1 = null;
         }
         if(this._AddBtn)
         {
            ObjectUtils.disposeObject(this._AddBtn);
            this._AddBtn = null;
         }
         if(this._AddBtn1)
         {
            ObjectUtils.disposeObject(this._AddBtn1);
            this._AddBtn1 = null;
         }
         if(this._MinusBtn)
         {
            ObjectUtils.disposeObject(this._MinusBtn);
            this._MinusBtn = null;
         }
         if(this._MinusBtn1)
         {
            ObjectUtils.disposeObject(this._MinusBtn1);
            this._MinusBtn1 = null;
         }
         if(this._SetInputBg)
         {
            ObjectUtils.disposeObject(this._SetInputBg);
            this._SetInputBg = null;
         }
         if(this._SetInputBg1)
         {
            ObjectUtils.disposeObject(this._SetInputBg1);
            this._SetInputBg1 = null;
         }
         if(this._setNumTxt)
         {
            ObjectUtils.disposeObject(this._setNumTxt);
            this._setNumTxt = null;
         }
         if(this._setNumTxt1)
         {
            ObjectUtils.disposeObject(this._setNumTxt1);
            this._setNumTxt1 = null;
         }
         if(this._NumerTxt)
         {
            ObjectUtils.disposeObject(this._NumerTxt);
            this._NumerTxt = null;
         }
         if(this._NumerTxt1)
         {
            ObjectUtils.disposeObject(this._NumerTxt1);
            this._NumerTxt1 = null;
         }
         if(this._seedBtn)
         {
            ObjectUtils.disposeObject(this._seedBtn);
            this._seedBtn = null;
         }
         if(this._FertilizerBtn)
         {
            ObjectUtils.disposeObject(this._FertilizerBtn);
            this._FertilizerBtn = null;
         }
         if(this._ResetBtn)
         {
            ObjectUtils.disposeObject(this._ResetBtn);
            this._ResetBtn = null;
         }
         if(this._okBtn)
         {
            ObjectUtils.disposeObject(this._okBtn);
            this._okBtn = null;
         }
         if(this._btmBg)
         {
            ObjectUtils.disposeObject(this._btmBg);
            this._btmBg = null;
         }
         if(this._helperSetViewSelectResult != null)
         {
            this._helperSetViewSelectResult = null;
         }
         this._findNumState = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
