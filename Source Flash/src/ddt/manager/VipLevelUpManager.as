package ddt.manager
{
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import ddt.action.FrameShowAction;
   import ddt.constants.CacheConsts;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.view.bossbox.VipLevelUpAwardsView;
   import flash.events.EventDispatcher;
   import road7th.comm.PackageIn;
   
   public class VipLevelUpManager extends EventDispatcher
   {
      
      private static var _instance:VipLevelUpManager;
       
      
      private var awardsFrame:VipLevelUpAwardsView;
      
      public function VipLevelUpManager()
      {
         super();
      }
      
      public static function get instance() : VipLevelUpManager
      {
         if(_instance == null)
         {
            _instance = new VipLevelUpManager();
         }
         return _instance;
      }
      
      public function initVIPLevelUpEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.VIP_LEVELUP,this.__vipLevelUp);
      }
      
      private function __vipLevelUp(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:InventoryItemInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:String = _loc2_.readUTF();
         var _loc4_:int = int(_loc2_.readByte());
         var _loc5_:Array = [];
         while(_loc2_.bytesAvailable)
         {
            _loc6_ = new InventoryItemInfo();
            _loc6_.TemplateID = _loc2_.readInt();
            _loc6_ = ItemManager.fill(_loc6_);
            _loc6_.Count = _loc2_.readInt();
            _loc6_.IsBinds = _loc2_.readBoolean();
            _loc6_.ValidDate = _loc2_.readInt();
            _loc6_.StrengthenLevel = _loc2_.readInt();
            _loc6_.AttackCompose = _loc2_.readInt();
            _loc6_.DefendCompose = _loc2_.readInt();
            _loc6_.AgilityCompose = _loc2_.readInt();
            _loc6_.LuckCompose = _loc2_.readInt();
            _loc5_.push(_loc6_);
         }
         this.awardsFrame = ComponentFactory.Instance.creat("vip.vipLevelUpawardFrame");
         this.awardsFrame.vipLevelUpGoodsList = _loc5_;
         if(CacheSysManager.isLock(CacheConsts.ALERT_IN_FIGHT))
         {
            CacheSysManager.getInstance().cache(CacheConsts.ALERT_IN_FIGHT,new FrameShowAction(this.awardsFrame));
         }
         else
         {
            this.awardsFrame.show();
         }
      }
   }
}
