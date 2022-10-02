package giftSystem.element
{
   import bagAndInfo.BagAndInfoManager;
   import bagAndInfo.info.PlayerInfoViewControl;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   import giftSystem.GiftController;
   import giftSystem.data.RecordItemInfo;
   
   public class RebackMenu extends Sprite
   {
      
      private static var _instance:RebackMenu;
       
      
      private var _BG:Bitmap;
      
      private var _rebackBtn:BaseButton;
      
      private var _checkBtn:BaseButton;
      
      private var _info:RecordItemInfo;
      
      public function RebackMenu()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public static function get Instance() : RebackMenu
      {
         if(_instance == null)
         {
            _instance = new RebackMenu();
         }
         return _instance;
      }
      
      private function initView() : void
      {
         this._BG = ComponentFactory.Instance.creatBitmap("bagAndInfo.cellMenu.CellMenuBGAsset");
         this._rebackBtn = ComponentFactory.Instance.creatComponentByStylename("RebackMenu.rebackBtn");
         this._checkBtn = ComponentFactory.Instance.creatComponentByStylename("RebackMenu.checkBtn");
         graphics.beginFill(0,0);
         graphics.drawRect(-3000,-3000,6000,6000);
         graphics.endFill();
         addChild(this._BG);
         addChild(this._rebackBtn);
         addChild(this._checkBtn);
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__mouseClick);
         this._rebackBtn.addEventListener(MouseEvent.CLICK,this.__reback);
         this._checkBtn.addEventListener(MouseEvent.CLICK,this.__check);
      }
      
      private function __mouseClick(param1:MouseEvent) : void
      {
         this.hide();
         SoundManager.instance.play("008");
      }
      
      private function __check(param1:MouseEvent) : void
      {
         PlayerInfoViewControl.viewByID(this._info.playerID);
         BagAndInfoManager.Instance.hideBagAndInfo();
         PlayerInfoViewControl.isOpenFromBag = true;
      }
      
      private function __reback(param1:MouseEvent) : void
      {
         setTimeout(GiftController.Instance.RebackClick,200,this._info.name);
      }
      
      public function show(param1:RecordItemInfo, param2:int, param3:int) : void
      {
         if(this._info != param1)
         {
            this._info = param1;
         }
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER);
         this.x = param2;
         this.y = param3;
      }
      
      public function hide() : void
      {
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
