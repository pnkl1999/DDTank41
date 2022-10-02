package ddt.view.buff.buffButton
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.view.tips.BuffTipInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class BuffButton extends Sprite implements Disposeable, ITipedDisplay
   {
      
      protected static var Setting:Boolean = false;
       
      
      protected var _info:BuffInfo;
      
      private var _canClick:Boolean;
      
      protected var _tipStyle:String;
      
      protected var _tipData:BuffTipInfo;
      
      protected var _tipDirctions:String;
      
      protected var _tipGapV:int;
      
      protected var _tipGapH:int;
      
      public function BuffButton(param1:String)
      {
         super();
         addChild(ComponentFactory.Instance.creatBitmap(param1));
         this._canClick = true;
         buttonMode = this._canClick;
         this._tipStyle = "core.buffTip";
         this._tipGapV = 2;
         this._tipGapH = 2;
         this._tipDirctions = "7,6,5,1,6,4";
         ShowTipManager.Instance.addTip(this);
         this.initEvents();
      }
      
      public static function createBuffButton(param1:int, param2:String = "") : BuffButton
      {
         var _loc3_:BuffButton = null;
         var _loc4_:BuffButton = null;
         var _loc5_:BuffButton = null;
         switch(param1)
         {
            case 1:
               return new DoubExpBuffButton();
            case 2:
               return new DoubGesteBuffButton();
            case 3:
               return new PreventKickBuffButton();
            case 4:
               return new PayBuffButton(param2);
            default:
               return null;
         }
      }
      
      private function initEvents() : void
      {
         addEventListener(MouseEvent.CLICK,this.__onclick);
         addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
      }
      
      protected function __onclick(param1:MouseEvent) : void
      {
         if(!this.CanClick)
         {
            return;
         }
         SoundManager.instance.play("008");
      }
      
      protected function __onMouseOver(param1:MouseEvent) : void
      {
         if(this._info && this._info.IsExist)
         {
            filters = ComponentFactory.Instance.creatFilters("lightFilter");
         }
      }
      
      protected function __onMouseOut(param1:MouseEvent) : void
      {
         if(this._info && this._info.IsExist)
         {
            filters = null;
         }
      }
      
      protected function checkBagLocked() : Boolean
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return false;
         }
         return true;
      }
      
      protected function buyBuff() : void
      {
         SocketManager.Instance.out.sendUseCard(-1,-1,[ShopManager.Instance.getMoneyShopItemByTemplateID(this._info.buffItemInfo.TemplateID).GoodsID],1);
      }
      
      protected function createTipRender() : Sprite
      {
         return new Sprite();
      }
      
      public function setSize(param1:Number, param2:Number) : void
      {
         param1 = param1;
         param2 = param2;
      }
      
      private function updateView() : void
      {
         if(this._info != null && this._info.IsExist)
         {
            filters = null;
         }
         else
         {
            filters = ComponentFactory.Instance.creatFilters("grayFilter");
         }
      }
      
      public function set CanClick(param1:Boolean) : void
      {
         this._canClick = param1;
         buttonMode = this._canClick;
      }
      
      public function get CanClick() : Boolean
      {
         return this._canClick;
      }
      
      public function set info(param1:BuffInfo) : void
      {
         this._info = param1;
         if(this._info.Type != BuffInfo.GROW_HELP && this._info.Type != BuffInfo.LABYRINTH_BUFF)
         {
            this.updateView();
         }
      }
      
      public function get info() : BuffInfo
      {
         return this._info;
      }
      
      protected function __onBuyResponse(param1:FrameEvent) : void
      {
         Setting = false;
         SoundManager.instance.play("008");
         (param1.target as BaseAlerFrame).removeEventListener(FrameEvent.RESPONSE,this.__onBuyResponse);
         (param1.target as BaseAlerFrame).dispose();
         if(param1.responseCode == FrameEvent.ENTER_CLICK || param1.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.buyBuff();
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._info = null;
         ShowTipManager.Instance.removeTip(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get tipStyle() : String
      {
         return this._tipStyle;
      }
      
      public function set tipStyle(param1:String) : void
      {
         this._tipStyle = param1;
      }
      
      public function get tipData() : Object
      {
         this._tipData = new BuffTipInfo();
         if(this._info)
         {
            this._tipData.isActive = this._info.IsExist;
            this._tipData.describe = this._info.description;
            this._tipData.name = this._info.buffName;
            this._tipData.isFree = false;
            this._tipData.day = this._info.getLeftTimeByUnit(TimeManager.DAY_TICKS);
            this._tipData.hour = this._info.getLeftTimeByUnit(TimeManager.HOUR_TICKS);
            this._tipData.min = this._info.getLeftTimeByUnit(TimeManager.Minute_TICKS);
         }
         return this._tipData;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._tipData = param1 as BuffTipInfo;
      }
      
      public function get tipDirctions() : String
      {
         return this._tipDirctions;
      }
      
      public function set tipDirctions(param1:String) : void
      {
         this._tipDirctions = param1;
      }
      
      public function get tipGapV() : int
      {
         return this._tipGapV;
      }
      
      public function set tipGapV(param1:int) : void
      {
         this._tipGapV = param1;
      }
      
      public function get tipGapH() : int
      {
         return this._tipGapH;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function set tipGapH(param1:int) : void
      {
         this._tipGapH = param1;
      }
   }
}
