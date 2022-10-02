package ddt.manager
{
   import com.pickgliss.ui.ComponentFactory;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.states.StateType;
   import ddt.view.qqTips.QQTipsInfo;
   import ddt.view.qqTips.QQTipsView;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.KeyboardEvent;
   import road7th.comm.PackageIn;
   
   public class QQtipsManager extends EventDispatcher
   {
      
      private static var _instance:QQtipsManager;
      
      public static const COLSE_QQ_TIPSVIEW:String = "Close_QQ_tipsView";
       
      
      private var _qqInfoList:Vector.<QQTipsInfo>;
      
      private var _isShowTipNow:Boolean;
      
      public var isGotoShop:Boolean = false;
      
      public var indexCurrentShop:int;
      
      public function QQtipsManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : QQtipsManager
      {
         if(_instance == null)
         {
            _instance = new QQtipsManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this._qqInfoList = new Vector.<QQTipsInfo>();
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.QQTIPS_GET_INFO,this.__getInfo);
      }
      
      private function __keyDown(param1:KeyboardEvent) : void
      {
      }
      
      private function __getInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:QQTipsInfo = new QQTipsInfo();
         _loc3_.title = _loc2_.readUTF();
         _loc3_.content = _loc2_.readUTF();
         _loc3_.maxLevel = _loc2_.readInt();
         _loc3_.minLevel = _loc2_.readInt();
         _loc3_.outInType = _loc2_.readInt();
         if(_loc3_.outInType == 0)
         {
            _loc3_.moduleType = _loc2_.readInt();
            _loc3_.inItemID = _loc2_.readInt();
         }
         else
         {
            _loc3_.url = _loc2_.readUTF();
         }
         if(_loc3_.minLevel <= PlayerManager.Instance.Self.Grade && PlayerManager.Instance.Self.Grade <= _loc3_.maxLevel)
         {
            if(this._qqInfoList.length > 0)
            {
               this._qqInfoList.splice(0,this._qqInfoList.length);
            }
            this._qqInfoList.push(_loc3_);
         }
         this.checkState();
      }
      
      public function checkState() : void
      {
         if(this._qqInfoList.length > 0 && this.getStateAble(StateManager.currentStateType))
         {
            if(this.isShowTipNow)
            {
               dispatchEvent(new Event(COLSE_QQ_TIPSVIEW));
            }
            this.__showQQTips();
         }
      }
      
      public function checkStateView(param1:String) : void
      {
         if(this._qqInfoList.length > 0 && this.getStateAble(param1))
         {
            this.__showQQTips();
         }
      }
      
      private function getStateAble(param1:String) : Boolean
      {
         if(param1 == StateType.CHURCH_ROOM_LIST || param1 == StateType.ROOM_LIST || param1 == StateType.CONSORTIA || param1 == StateType.DUNGEON_LIST || param1 == StateType.HOT_SPRING_ROOM_LIST || param1 == StateType.FIGHT_LIB || param1 == StateType.ACADEMY_REGISTRATION || param1 == StateType.CIVIL || param1 == StateType.TOFFLIST)
         {
            return true;
         }
         return false;
      }
      
      private function __showQQTips() : void
      {
         var _loc1_:QQTipsView = ComponentFactory.Instance.creatCustomObject("coreIconQQ.QQTipsView");
         _loc1_.qqInfo = this._qqInfoList.shift();
         _loc1_.show();
         this.isShowTipNow = true;
      }
      
      public function set isShowTipNow(param1:Boolean) : void
      {
         this._isShowTipNow = param1;
      }
      
      public function get isShowTipNow() : Boolean
      {
         return this._isShowTipNow;
      }
      
      public function gotoShop(param1:int) : void
      {
         if(param1 > 3)
         {
            return;
         }
         this.isGotoShop = true;
         this.indexCurrentShop = param1;
         StateManager.setState(StateType.SHOP);
      }
   }
}
