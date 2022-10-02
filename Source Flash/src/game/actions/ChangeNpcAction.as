package game.actions
{
   import ddt.data.PathInfo;
   import ddt.events.CrazyTankSocketEvent;
   import game.GameManager;
   import game.model.Living;
   import game.model.SmallEnemy;
   import game.objects.GameSmallEnemy;
   import game.objects.SimpleBox;
   import game.view.GameView;
   import game.view.map.MapView;
   import road7th.comm.PackageIn;
   
   public class ChangeNpcAction extends BaseAction
   {
       
      
      private var _gameView:GameView;
      
      private var _map:MapView;
      
      private var _info:Living;
      
      private var _pkg:PackageIn;
      
      private var _event:CrazyTankSocketEvent;
      
      private var _ignoreSmallEnemy:Boolean;
      
      public function ChangeNpcAction(param1:GameView, param2:MapView, param3:Living, param4:CrazyTankSocketEvent, param5:PackageIn, param6:Boolean)
      {
         super();
         this._gameView = param1;
         this._event = param4;
         this._event.executed = false;
         this._pkg = param5;
         this._map = param2;
         this._info = param3;
         this._ignoreSmallEnemy = param6;
      }
      
      private function syncMap() : void
      {
         var _loc10_:int = 0;
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         _loc10_ = 0;
         var _loc11_:uint = 0;
         var _loc12_:SimpleBox = null;
         if(this._pkg)
         {
            _loc1_ = this._pkg.readBoolean();
            _loc2_ = this._pkg.readByte();
            _loc3_ = this._pkg.readByte();
            _loc4_ = this._pkg.readByte();
            _loc5_ = new Array();
            _loc5_ = [_loc1_,_loc2_,_loc3_,_loc4_];
            GameManager.Instance.Current.setWind(GameManager.Instance.Current.wind,false,_loc5_);
            this._pkg.readBoolean();
            this._pkg.readInt();
            _loc6_ = this._pkg.readInt();
            _loc7_ = 0;
            while(_loc7_ < _loc6_)
            {
               _loc8_ = this._pkg.readInt();
               _loc9_ = this._pkg.readInt();
               _loc10_ = this._pkg.readInt();
               _loc11_ = this._pkg.readInt();
               _loc12_ = new SimpleBox(_loc8_,String(PathInfo.GAME_BOXPIC),_loc11_);
               _loc12_.x = _loc9_;
               _loc12_.y = _loc10_;
               this._map.addPhysical(_loc12_);
               _loc7_++;
            }
         }
      }
      
      private function updateNpc() : void
      {
         var _loc1_:Living = null;
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         for each(_loc1_ in GameManager.Instance.Current.livings)
         {
            _loc1_.beginNewTurn();
         }
         this._map.cancelFocus();
         this._gameView.setCurrentPlayer(this._info);
         if(!this._map.smallMap.locked)
         {
            this.focusOnSmallEnemy();
         }
         if(!this._ignoreSmallEnemy)
         {
            this._ignoreSmallEnemy = true;
            this._gameView.updateControlBarState(GameManager.Instance.Current.selfGamePlayer);
            return;
         }
      }
      
      private function getClosestEnemy() : SmallEnemy
      {
         var _loc3_:SmallEnemy = null;
         var _loc4_:Living = null;
         var _loc1_:int = -1;
         var _loc2_:int = GameManager.Instance.Current.selfGamePlayer.pos.x;
         for each(_loc4_ in GameManager.Instance.Current.livings)
         {
            if(_loc4_ is SmallEnemy && _loc4_.isLiving && _loc4_.typeLiving != 3)
            {
               if(_loc1_ == -1 || Math.abs(_loc4_.pos.x - _loc2_) < _loc1_)
               {
                  _loc1_ = Math.abs(_loc4_.pos.x - _loc2_);
                  _loc3_ = _loc4_ as SmallEnemy;
               }
            }
         }
         return _loc3_;
      }
      
      private function focusOnSmallEnemy() : void
      {
         var _loc1_:SmallEnemy = this.getClosestEnemy();
         if(_loc1_)
         {
            if(_loc1_.LivingID && this._map.getPhysical(_loc1_.LivingID))
            {
               (this._map.getPhysical(_loc1_.LivingID) as GameSmallEnemy).needFocus();
               this._map.currentFocusedLiving = this._map.getPhysical(_loc1_.LivingID) as GameSmallEnemy;
            }
         }
      }
      
      override public function execute() : void
      {
         this._event.executed = true;
         this.syncMap();
         this.updateNpc();
         _isFinished = true;
      }
   }
}
