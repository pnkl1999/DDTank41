package tryonSystem
{
   import bagAndInfo.cell.PersonalInfoCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MovieImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.character.CharactoryFactory;
   import ddt.view.character.RoomCharacter;
   import equipretrieve.effect.AnimationControl;
   import equipretrieve.effect.GlowFilterAnimation;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import road7th.data.DictionaryData;
   
   public class TryonPanelView extends Sprite implements Disposeable
   {
      
      private static const CELL_PLACE:Array = [0,1,2,3,4,5,11,13];
       
      
      private var _controller:TryonSystemController;
      
      private var _model:TryonModel;
      
      private var _bg:Scale9CornerImage;
      
      private var _bg1:Scale9CornerImage;
      
      private var _tryTxt:Bitmap;
      
      private var _chBg:Bitmap;
      
      private var _hideTxt:Bitmap;
      
      private var _hideBg:Bitmap;
      
      private var _hideHatBtn:SelectedCheckButton;
      
      private var _hideGlassBtn:SelectedCheckButton;
      
      private var _hideSuitBtn:SelectedCheckButton;
      
      private var _hideWingBtn:SelectedCheckButton;
      
      private var _bagItems:DictionaryData;
      
      private var _character:RoomCharacter;
      
      private var _itemList:SimpleTileList;
      
      private var _cells:Array;
      
      private var _bagCells:Array;
      
      private var _nickName:FilterFrameText;
      
      private var _effect:MovieClip;
      
      public function TryonPanelView(param1:TryonSystemController)
      {
         super();
         this._controller = param1;
         this._model = this._controller.model;
         this._cells = [];
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var _loc2_:InventoryItemInfo = null;
         var _loc3_:int = 0;
         var _loc4_:Sprite = null;
         var _loc5_:TryonCell = null;
         var _loc6_:MovieImage = null;
         var _loc7_:GlowFilterAnimation = null;
         var _loc8_:PersonalInfoCell = null;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.tryOnBigBg");
         addChild(this._bg);
         this._bg1 = ComponentFactory.Instance.creatComponentByStylename("core.tryOnSmallBg");
         addChild(this._bg1);
         this._tryTxt = ComponentFactory.Instance.creatBitmap("asset.tryOnTxtImage");
         addChild(this._tryTxt);
         this._chBg = ComponentFactory.Instance.creatBitmap("asset.core.tryonCharaterBgAsset");
         addChild(this._chBg);
         this._hideBg = ComponentFactory.Instance.creatBitmap("asset.core.hideBgAsset");
         addChild(this._hideBg);
         this._hideTxt = ComponentFactory.Instance.creatBitmap("asset.core.hideTxtAsset");
         addChild(this._hideTxt);
         this._hideGlassBtn = ComponentFactory.Instance.creatComponentByStylename("tryon.HideHatCheckBox");
         addChild(this._hideGlassBtn);
         this._hideHatBtn = ComponentFactory.Instance.creatComponentByStylename("tryon.HideGlassCheckBox");
         addChild(this._hideHatBtn);
         this._hideSuitBtn = ComponentFactory.Instance.creatComponentByStylename("tryon.HideSuitCheckBox");
         addChild(this._hideSuitBtn);
         this._hideWingBtn = ComponentFactory.Instance.creatComponentByStylename("tryon.HideWingCheckBox");
         addChild(this._hideWingBtn);
         this._hideHatBtn.text = LanguageMgr.GetTranslation("shop.ShopIITryDressView.hideHat");
         this._hideGlassBtn.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.glass");
         this._hideSuitBtn.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.suit");
         this._hideWingBtn.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.wing");
         this._hideGlassBtn.selected = this._model.playerInfo.getGlassHide();
         this._hideSuitBtn.selected = this._model.playerInfo.getSuitesHide();
         this._hideWingBtn.selected = this._model.playerInfo.wingHide;
         this._character = CharactoryFactory.createCharacter(this._model.playerInfo,"room") as RoomCharacter;
         this._character.x = 160;
         this._character.y = 26;
         addChild(this._character);
         this._character.show(false,-1);
         this._effect = ComponentFactory.Instance.creat("asset.core.tryonEffect");
         PositionUtils.setPos(this._effect,"tryonSystem.TryonPanelView.effectPos");
         this._effect.stop();
         addChild(this._effect);
         this._itemList = new SimpleTileList(2);
         this._itemList.vSpace = 50;
         this._itemList.hSpace = 50;
         this._itemList.x = 219;
         this._itemList.y = 32;
         var _loc1_:AnimationControl = new AnimationControl();
         _loc1_.addEventListener(Event.COMPLETE,this._cellLightComplete);
         for each(_loc2_ in this._model.items)
         {
            _loc4_ = new Sprite();
            _loc4_.graphics.beginFill(16777215,0);
            _loc4_.graphics.drawRect(0,0,43,43);
            _loc4_.graphics.endFill();
            _loc5_ = new TryonCell(_loc4_);
            _loc5_.info = _loc2_;
            _loc5_.addEventListener(MouseEvent.CLICK,this.__onClick);
            _loc5_.buttonMode = true;
            this._itemList.addChild(_loc5_);
            this._cells.push(_loc5_);
            if(_loc2_.CategoryID == 3)
            {
               this._hideHatBtn.selected = true;
               this._model.playerInfo.setHatHide(this._hideHatBtn.selected);
            }
            else
            {
               this._hideHatBtn.selected = this._model.playerInfo.getHatHide();
            }
            _loc6_ = ComponentFactory.Instance.creatComponentByStylename("asset.core.itemBigShinelight");
            _loc6_.movie.play();
            _loc5_.addChildAt(_loc6_,1);
            _loc7_ = new GlowFilterAnimation();
            _loc7_.start(_loc6_,false,16763955,0,0);
            _loc7_.addMovie(0,0,19,0);
            _loc1_.addMovies(_loc7_);
         }
         addChild(this._itemList);
         this._bagItems = this._model.bagItems;
         this._bagCells = [];
         _loc3_ = 0;
         while(_loc3_ < 8)
         {
            _loc8_ = new PersonalInfoCell(_loc3_,this._bagItems[CELL_PLACE[_loc3_]] as InventoryItemInfo,true);
            this._bagCells.push(_loc8_);
            _loc3_++;
         }
         this._nickName = ComponentFactory.Instance.creatComponentByStylename("tryonNickNameText");
         addChild(this._nickName);
         this._nickName.text = PlayerManager.Instance.Self.NickName;
         _loc1_.startMovie();
      }
      
      private function _cellLightComplete(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MovieImage = null;
         param1.currentTarget.removeEventListener(Event.COMPLETE,this._cellLightComplete);
         if(this._cells)
         {
            _loc2_ = this._cells.length;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = this._cells[_loc3_].removeChildAt(1);
               _loc4_.dispose();
               _loc3_++;
            }
         }
      }
      
      private function initEvents() : void
      {
         this._hideGlassBtn.addEventListener(MouseEvent.CLICK,this.__hideGlassClickHandler);
         this._hideHatBtn.addEventListener(MouseEvent.CLICK,this.__hideHatClickHandler);
         this._hideSuitBtn.addEventListener(MouseEvent.CLICK,this.__hideSuitClickHandler);
         this._hideWingBtn.addEventListener(MouseEvent.CLICK,this.__hideWingClickHandler);
         this._model.addEventListener(Event.CHANGE,this.__onchange);
      }
      
      private function removeEvents() : void
      {
         this._hideGlassBtn.removeEventListener(MouseEvent.CLICK,this.__hideGlassClickHandler);
         this._hideHatBtn.removeEventListener(MouseEvent.CLICK,this.__hideHatClickHandler);
         this._hideSuitBtn.removeEventListener(MouseEvent.CLICK,this.__hideSuitClickHandler);
         this._hideWingBtn.removeEventListener(MouseEvent.CLICK,this.__hideWingClickHandler);
         this._model.removeEventListener(Event.CHANGE,this.__onchange);
      }
      
      private function __onchange(param1:Event) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < 8)
         {
            this._bagCells[_loc2_].info = this._bagItems[CELL_PLACE[_loc2_]] as InventoryItemInfo;
            _loc2_++;
         }
      }
      
      private function __hideWingClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._model.playerInfo.wingHide = this._hideWingBtn.selected;
      }
      
      private function __hideSuitClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._model.playerInfo.setSuiteHide(this._hideSuitBtn.selected);
      }
      
      private function __hideHatClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._model.playerInfo.setHatHide(this._hideHatBtn.selected);
      }
      
      private function __hideGlassClickHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._model.playerInfo.setGlassHide(this._hideGlassBtn.selected);
      }
      
      private function __onClick(param1:MouseEvent) : void
      {
         var _loc2_:TryonCell = null;
         SoundManager.instance.play("008");
         for each(_loc2_ in this._cells)
         {
            _loc2_.selected = false;
         }
         TryonCell(param1.currentTarget).selected = true;
         this._model.selectedItem = TryonCell(param1.currentTarget).info as InventoryItemInfo;
         if(this._effect)
         {
            this._effect.play();
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:TryonCell = null;
         var _loc2_:PersonalInfoCell = null;
         this.removeEvents();
         for each(_loc1_ in this._cells)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__onClick);
            _loc1_.dispose();
         }
         this._cells = null;
         for each(_loc2_ in this._bagCells)
         {
            _loc2_.dispose();
         }
         this._bagCells = null;
         if(this._effect)
         {
            if(this._effect.parent)
            {
               this._effect.parent.removeChild(this._effect);
            }
            this._effect = null;
         }
         this._bg1.dispose();
         this._bg1 = null;
         this._bg.dispose();
         this._bg = null;
         ObjectUtils.disposeObject(this._tryTxt);
         this._tryTxt = null;
         ObjectUtils.disposeObject(this._chBg);
         this._chBg = null;
         ObjectUtils.disposeObject(this._hideBg);
         this._hideBg = null;
         ObjectUtils.disposeObject(this._hideTxt);
         this._hideTxt = null;
         ObjectUtils.disposeObject(this._hideGlassBtn);
         this._hideGlassBtn = null;
         ObjectUtils.disposeObject(this._hideSuitBtn);
         this._hideSuitBtn = null;
         ObjectUtils.disposeObject(this._hideWingBtn);
         this._hideWingBtn = null;
         ObjectUtils.disposeObject(this._nickName);
         this._nickName = null;
         this._character.dispose();
         this._character = null;
         this._itemList.dispose();
         this._itemList = null;
         this._bagItems = null;
         this._model = null;
         this._controller = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
