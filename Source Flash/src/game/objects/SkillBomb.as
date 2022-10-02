package game.objects
{
   import ddt.manager.SocketManager;
   import flash.events.Event;
   import game.actions.SkillActions.LaserAction;
   import game.model.GameInfo;
   import game.model.Living;
   import game.model.Player;
   import game.view.Bomb;
   import game.view.map.MapView;
   import phy.bombs.BaseBomb;
   import phy.maps.Map;
   
   public class SkillBomb extends BaseBomb
   {
       
      
      private var _info:Bomb;
      
      private var _owner:Living;
      
      private var _lifeTime:int;
      
      private var _cunrrentAction:BombAction;
      
      private var _laserAction:LaserAction;
      
      private var _game:GameInfo;
      
      public function SkillBomb(param1:Bomb, param2:Living)
      {
         this._info = param1;
         this._lifeTime = 0;
         this._owner = param2;
         super(this._info.Id);
      }
      
      public function get map() : MapView
      {
         return _map as MapView;
      }
      
      override public function setMap(param1:Map) : void
      {
         super.setMap(param1);
         if(param1)
         {
            this._game = this.map.game;
         }
      }
      
      override public function update(param1:Number) : void
      {
         var _loc2_:Living = null;
         var _loc3_:Living = null;
         if(this._cunrrentAction == null)
         {
            this._cunrrentAction = this._info.Actions.shift();
         }
         if(this._cunrrentAction == null)
         {
            bomb();
         }
         else if(this._cunrrentAction.type == ActionType.Laser)
         {
            if(this._laserAction == null)
            {
               _loc2_ = this._game.findLiving(this._cunrrentAction.param1);
               this._laserAction = new LaserAction(_loc2_,this.map,this._cunrrentAction.param2);
               this._laserAction.prepare();
            }
            else if(this._laserAction.isFinished)
            {
               this._cunrrentAction = this._info.Actions.shift();
            }
            else
            {
               this._laserAction.execute();
            }
         }
         else if(this._cunrrentAction.type == ActionType.KILL_PLAYER)
         {
            _loc3_ = this._game.findLiving(this._cunrrentAction.param1);
            if(_loc3_)
            {
               if(Math.abs(_loc3_.blood - this._cunrrentAction.param4) > 30000 && this._owner is Player)
               {
                  SocketManager.Instance.out.sendErrorMsg("客户端发现异常:" + this._owner.playerInfo.NickName + "打出单发炮弹" + Math.abs(_loc3_.blood - this._cunrrentAction.param4) + "的伤害");
               }
               _loc3_.updateBlood(this._cunrrentAction.param4,this._cunrrentAction.param3,0 - this._cunrrentAction.param2);
               _loc3_.isHidden = false;
               _loc3_.bomd();
            }
            this._cunrrentAction = this._info.Actions.shift();
         }
         else
         {
            this._cunrrentAction = this._info.Actions.shift();
         }
      }
      
      override protected function DigMap() : void
      {
      }
      
      override public function die() : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
         super.die();
         dispose();
      }
   }
}
