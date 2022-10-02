package game.objects
{
   import ddt.manager.SocketManager;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import game.model.GameInfo;
   import game.model.Living;
   import game.model.Player;
   import phy.object.PhysicalObj;
   import room.RoomManager;
   import room.model.RoomInfo;
   
   public class BombAction
   {
       
      
      private var _time:int;
      
      private var _type:int;
      
      private var _param1:int;
      
      public var _param2:int;
      
      public var _param3:int;
      
      public var _param4:int;
      
      public function BombAction(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int)
      {
         super();
         this._time = param1;
         this._type = param2;
         this._param1 = param3;
         this._param2 = param4;
         this._param3 = param5;
         this._param4 = param6;
      }
      
      public function get param1() : int
      {
         return this._param1;
      }
      
      public function get param2() : int
      {
         return this._param2;
      }
      
      public function get param3() : int
      {
         return this._param3;
      }
      
      public function get param4() : int
      {
         return this._param4;
      }
      
      public function get time() : int
      {
         return this._time;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function execute(param1:SimpleBomb, param2:GameInfo) : void
      {
         var _loc3_:PhysicalObj = null;
         var _loc4_:Living = null;
         var _loc5_:Living = null;
         var _loc6_:Living = null;
         var _loc7_:Living = null;
         var _loc8_:Player = null;
         var _loc9_:Living = null;
         var _loc10_:Player = null;
         var _loc11_:Living = null;
         var _loc12_:Living = null;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:Living = null;
         var _loc16_:Living = null;
         var _loc17_:Living = null;
         var _loc18_:Player = null;
         var _loc19_:Living = null;
         var _loc20_:Dictionary = null;
         switch(this._type)
         {
            case ActionType.PICK:
               _loc3_ = param1.map.getPhysical(this._param1);
               if(_loc3_)
               {
                  _loc3_.collidedByObject(param1);
               }
               break;
            case ActionType.BOMB:
               param1.x = this._param1;
               param1.y = this._param2;
               param1.bomb();
               break;
            case ActionType.START_MOVE:
               _loc4_ = param2.findLiving(this._param1);
               if(_loc4_ is Player)
               {
                  (_loc4_ as Player).playerMoveTo(1,new Point(this._param2,this._param3),_loc4_.direction,this._param4 != 0);
               }
               else if(_loc4_ != null)
               {
                  _loc4_.fallTo(new Point(this._param2,this._param3),Player.FALL_SPEED);
               }
               break;
            case ActionType.FLY_OUT:
               param1.die();
               break;
            case ActionType.KILL_PLAYER:
               _loc5_ = param2.findLiving(this._param1);
               if(_loc5_)
               {
                  if(Math.abs(_loc5_.blood - this._param4) > 30000 && param1 && param1.owner && param1.owner is Player && param1.owner.playerInfo)
                  {
                     SocketManager.Instance.out.sendErrorMsg("客户端发现异常:" + param1.owner.playerInfo.NickName + "打出单发炮弹" + Math.abs(_loc5_.blood - this._param4) + "的伤害");
                  }
                  _loc5_.updateBlood(this._param4,this._param3,0 - this._param2);
                  _loc5_.isHidden = false;
               }
               break;
            case ActionType.TRANSLATE:
               param1.owner.transmit(new Point(this._param1,this._param2));
               break;
            case ActionType.FORZEN:
               _loc6_ = param2.findLiving(this._param1);
               if(_loc6_)
               {
                  _loc6_.isFrozen = true;
                  _loc6_.isHidden = false;
               }
               break;
            case ActionType.CHANGE_SPEED:
               param1.setSpeedXY(new Point(this._param1,this._param2));
               param1.clearWG();
               if(this._param3 >= 0)
               {
                  _loc19_ = param2.findLiving(this._param3);
                  if(_loc19_)
                  {
                     _loc19_.playSkillMovie("guild");
                  }
               }
               break;
            case ActionType.UNFORZEN:
               _loc7_ = param2.findLiving(this._param1);
               if(_loc7_)
               {
                  _loc7_.isFrozen = false;
               }
               break;
            case ActionType.DANER:
               _loc8_ = param2.findPlayer(this._param1);
               if(_loc8_ && _loc8_.isLiving)
               {
                  _loc8_.dander = this._param2;
               }
               break;
            case ActionType.CURE:
               _loc9_ = param2.findLiving(this._param1);
               if(_loc9_)
               {
                  _loc9_.showAttackEffect(2);
                  _loc9_.updateBlood(this._param2,0,this._param3);
               }
               break;
            case ActionType.GEM_DEFENSE_CHANGED:
               _loc10_ = param2.findPlayer(this._param1);
               if(_loc10_)
               {
                  _loc10_.gemDefense = true;
               }
               break;
            case ActionType.CHANGE_STATE:
               _loc11_ = param2.findLiving(this._param1);
               if(_loc11_)
               {
                  _loc11_.State = this._param2;
               }
               break;
            case ActionType.DO_ACTION:
               _loc12_ = param2.findLiving(this._param1);
               if(_loc12_)
               {
                  _loc12_.playMovie(ActionType.ACTION_TYPES[this._param4]);
               }
               break;
            case ActionType.PLAYBUFFER:
               _loc13_ = this._param2;
               _loc14_ = this._param1;
               break;
            case ActionType.BOMBED:
               _loc15_ = param2.findLiving(this._param1);
               _loc15_.bomd();
               break;
            case ActionType.PUP:
               _loc16_ = param2.findLiving(this._param1);
               if(_loc16_)
               {
                  _loc16_.showAttackEffect(ActionType.PUP);
               }
               break;
            case ActionType.AUP:
               _loc17_ = param2.findLiving(this._param1);
               if(_loc17_)
               {
                  _loc17_.showAttackEffect(ActionType.AUP);
               }
               break;
            case ActionType.PET:
               _loc18_ = Player(param2.findLiving(this._param1));
               if(_loc18_ && RoomManager.Instance.current.type != RoomInfo.ACTIVITY_DUNGEON_ROOM)
               {
                  _loc20_ = _loc18_.currentPet.petBeatInfo;
                  _loc18_.petBeat(String(_loc20_["actionName"]),Point(_loc20_["targetPoint"]),_loc20_["targets"]);
               }
         }
      }
   }
}
