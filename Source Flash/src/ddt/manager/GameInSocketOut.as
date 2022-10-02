package ddt.manager
{
   import ddt.data.socket.CrazyTankPackageType;
   import ddt.data.socket.GameRoomPackageType;
   import ddt.data.socket.ePackageType;
   import flash.geom.Point;
   import road7th.comm.ByteSocket;
   import road7th.comm.PackageOut;
   
   public class GameInSocketOut
   {
      
      private static var _socket:ByteSocket = SocketManager.Instance.socket;
       
      
      public function GameInSocketOut()
      {
         super();
      }
      
      public static function sendGetScenePlayer(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.SCENE_USERS_LIST);
         _loc2_.writeByte(param1);
         _loc2_.writeByte(6);
         sendPackage(_loc2_);
      }
      
      public static function sendInviteGame(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_INVITE);
         _loc2_.writeInt(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendBuyProp(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.PROP_BUY);
         _loc2_.writeInt(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendSellProp(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.PROP_SELL);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         sendPackage(_loc3_);
      }
      
      public static function sendGameRoomSetUp(param1:int, param2:int, param3:Boolean = false, param4:String = "", param5:String = "", param6:int = 2, param7:int = 0, param8:int = 0, param9:Boolean = false, param10:int = 0) : void
      {
         var _loc11_:int = PlayerManager.Instance.Self.Grade < 5 ? int(int(4)) : int(int(param6));
         var _loc12_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc12_.writeInt(GameRoomPackageType.GAME_ROOM_SETUP_CHANGE);
         _loc12_.writeInt(param1);
         _loc12_.writeByte(param2);
         _loc12_.writeBoolean(param3);
         _loc12_.writeUTF(param4);
         _loc12_.writeUTF(param5);
         _loc12_.writeByte(_loc11_);
         _loc12_.writeByte(param7);
         _loc12_.writeInt(param8);
         _loc12_.writeBoolean(param9);
         _loc12_.writeInt(param10);
         sendPackage(_loc12_);
      }
      
      public static function sendCreateRoom(param1:String, param2:int, param3:int = 2, param4:String = "") : void
      {
         var _loc5_:int = PlayerManager.Instance.Self.Grade < 5 ? int(int(4)) : int(int(param3));
         var _loc6_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc6_.writeInt(GameRoomPackageType.GAME_ROOM_CREATE);
         _loc6_.writeByte(param2);
         _loc6_.writeByte(_loc5_);
         _loc6_.writeUTF(param1);
         _loc6_.writeUTF(param4);
         sendPackage(_loc6_);
      }
      
      public static function sendGameRoomPlaceState(param1:int, param2:int, param3:Boolean = false, param4:int = -100) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc5_.writeInt(GameRoomPackageType.GAME_ROOM_UPDATE_PLACE);
         _loc5_.writeByte(param1);
         _loc5_.writeInt(param2);
         _loc5_.writeBoolean(param3);
         _loc5_.writeInt(param4);
         sendPackage(_loc5_);
      }
      
      public static function sendGameRoomKick(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc2_.writeInt(GameRoomPackageType.GAME_ROOM_KICK);
         _loc2_.writeByte(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendExitScene() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.SCENE_REMOVE_USER);
         sendPackage(_loc1_);
      }
      
      public static function sendGamePlayerExit() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc1_.writeInt(GameRoomPackageType.GAME_ROOM_REMOVEPLAYER);
         sendPackage(_loc1_);
      }
      
      public static function sendGameTeam(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc2_.writeInt(GameRoomPackageType.GAME_TEAM);
         _loc2_.writeByte(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendFlagMode(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.WANNA_LEADER);
         _loc2_.writeBoolean(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendGameStart() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc1_.writeInt(GameRoomPackageType.GAME_START);
         sendPackage(_loc1_);
      }
      
      public static function sendGameMissionStart(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(CrazyTankPackageType.GAME_MISSION_START);
         _loc2_.writeBoolean(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendGameMissionPrepare(param1:int, param2:Boolean) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc3_.writeByte(CrazyTankPackageType.GAME_MISSION_PREPARE);
         _loc3_.writeBoolean(param2);
         sendPackage(_loc3_);
      }
      
      public static function sendLoadingProgress(param1:Number) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.LOAD);
         _loc2_.writeInt(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendPlayerState(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc2_.writeInt(GameRoomPackageType.GAME_PLAYER_STATE_CHANGE);
         _loc2_.writeByte(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendGameCMDBlast(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc5_.writeByte(CrazyTankPackageType.BLAST);
         _loc5_.writeInt(param1);
         _loc5_.writeInt(param2);
         _loc5_.writeInt(param3);
         _loc5_.writeInt(param4);
         sendPackage(_loc5_);
      }
      
      public static function sendGameCMDChange(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         var _loc6_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc6_.writeByte(CrazyTankPackageType.CHANGEBALL);
         _loc6_.writeInt(param1);
         _loc6_.writeInt(param2);
         _loc6_.writeInt(param3);
         _loc6_.writeInt(param4);
         _loc6_.writeInt(param5);
         sendPackage(_loc6_);
      }
      
      public static function sendGameCMDDirection(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.DIRECTION);
         _loc2_.writeInt(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendGameCMDStunt(param1:int = 0) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.STUNT);
         _loc2_.writeByte(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendGameCMDShoot(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc5_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc5_.writeByte(CrazyTankPackageType.FIRE);
         _loc5_.writeInt(int(param1));
         _loc5_.writeInt(int(param2));
         _loc5_.writeInt(int(param3));
         _loc5_.writeInt(int(param4));
         sendPackage(_loc5_);
      }
      
      public static function sendGameSkipNext(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.SKIPNEXT);
         _loc2_.writeByte(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendGameStartMove(param1:Number, param2:int, param3:int, param4:Number, param5:Boolean, param6:Number) : void
      {
         var _loc7_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc7_.writeByte(CrazyTankPackageType.MOVESTART);
         _loc7_.writeBoolean(true);
         _loc7_.writeByte(param1);
         _loc7_.writeInt(param2);
         _loc7_.writeInt(param3);
         _loc7_.writeByte(param4);
         _loc7_.writeBoolean(param5);
         _loc7_.writeShort(param6);
         sendPackage(_loc7_);
      }
      
      public static function sendGameStopMove(param1:int, param2:int, param3:Boolean) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc4_.writeByte(CrazyTankPackageType.MOVESTOP);
         _loc4_.writeInt(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeBoolean(param3);
         sendPackage(_loc4_);
      }
      
      public static function sendGameTakeOut(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.TAKE_CARD);
         _loc2_.writeByte(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendBossTakeOut(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.BOSS_TAKE_CARD);
         _loc2_.writeByte(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendGetTropToBag(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_TAKE_TEMP);
         _loc2_.writeInt(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendShootTag(param1:Boolean, param2:int = 0) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc3_.writeByte(CrazyTankPackageType.FIRE_TAG);
         _loc3_.writeBoolean(param1);
         if(param1)
         {
            _loc3_.writeByte(param2);
         }
         sendPackage(_loc3_);
      }
      
      public static function sendBeat(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc4_.writeByte(CrazyTankPackageType.BEAT);
         _loc4_.writeShort(param1);
         _loc4_.writeShort(param2);
         _loc4_.writeShort(param3);
         sendPackage(_loc4_);
      }
      
      public static function sendThrowProp(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(CrazyTankPackageType.PROP_DELETE);
         _loc2_.writeInt(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendUseProp(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc4_.writeByte(CrazyTankPackageType.PROP);
         _loc4_.writeByte(param1);
         _loc4_.writeInt(param2);
         _loc4_.writeInt(param3);
         sendPackage(_loc4_);
      }
      
      public static function sendCancelWait() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc1_.writeInt(GameRoomPackageType.GAME_PICKUP_CANCEL);
         sendPackage(_loc1_);
      }
      
      public static function sendGameStyle(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_ROOM);
         _loc2_.writeInt(GameRoomPackageType.GAME_PICKUP_STYLE);
         _loc2_.writeInt(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendGhostTarget(param1:Point) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.GHOST_TARGET);
         _loc2_.writeInt(param1.x);
         _loc2_.writeInt(param1.y);
         sendPackage(_loc2_);
      }
      
      public static function sendPaymentTakeCard(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.PAYMENT_TAKE_CARD);
         _loc2_.writeByte(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendMissionTryAgain(param1:int, param2:Boolean, param3:Boolean = true) : void
      {
         var _loc4_:PackageOut = new PackageOut(91);
         _loc4_.writeByte(119);
         _loc4_.writeInt(param1);
         _loc4_.writeBoolean(param2);
         _loc4_.writeBoolean(param3);
         sendPackage(_loc4_);
      }
      
      public static function sendFightLibInfoChange(param1:int, param2:int = -1) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc3_.writeByte(CrazyTankPackageType.FIGHT_LIB_INFO_CHANGE);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         sendPackage(_loc3_);
      }
      
      public static function sendPassStory() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc1_.writeByte(CrazyTankPackageType.PASS_STORY);
         _loc1_.writeBoolean(true);
         sendPackage(_loc1_);
      }
      
      public static function sendClientScriptStart() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc1_.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
         _loc1_.writeInt(3);
         sendPackage(_loc1_);
      }
      
      public static function sendClientScriptEnd() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc1_.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
         _loc1_.writeInt(2);
         sendPackage(_loc1_);
      }
      
      public static function sendFightLibAnswer(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc3_.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
         _loc3_.writeInt(4);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         sendPackage(_loc3_);
      }
      
      public static function sendFightLibReanswer() : void
      {
         var _loc1_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc1_.writeByte(CrazyTankPackageType.GENERAL_COMMAND);
         _loc1_.writeInt(5);
         sendPackage(_loc1_);
      }
      
      public static function sendUpdatePlayStep(param1:String) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.MISSION_CMD);
         _loc2_.writeInt(6);
         _loc2_.writeUTF(param1);
         sendPackage(_loc2_);
      }
      
      private static function sendPackage(param1:PackageOut) : void
      {
         _socket.send(param1);
      }
      
      public static function sendFirstRechargeGetAward(param1:int) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.FIRSTRECHARGE);
         _loc2_.writeInt(param1);
         sendPackage(_loc2_);
      }
      
      public static function sendNoviceActivityGetAward(param1:int, param2:int) : void
      {
         var _loc3_:PackageOut = new PackageOut(ePackageType.NOVICEACTIVITY);
         _loc3_.writeInt(param1);
         _loc3_.writeInt(param2);
         sendPackage(_loc3_);
      }
      
      public static function sendTransmissionGate(param1:Boolean) : void
      {
         var _loc2_:PackageOut = new PackageOut(ePackageType.GAME_CMD);
         _loc2_.writeByte(CrazyTankPackageType.DELIVER);
         _loc2_.writeBoolean(param1);
         sendPackage(_loc2_);
      }
	  
	  public static function sendBringUpEat(param1:int, ... rest) : void
	  {
		  var _loc3_:int = 0;
		  var _loc4_:PackageOut = new PackageOut(ePackageType.EQUIP_BRING_UP);
		  _loc4_.writeInt(param1);
		  if(param1 > 0)
		  {
			  rest = rest[0];
			  _loc3_ = 0;
			  while(_loc3_ < param1)
			  {
				  _loc4_.writeInt(rest.shift());
				  _loc4_.writeInt(rest.shift());
				  _loc3_++;
			  }
		  }
		  else
		  {
			  _loc4_.writeInt(rest.shift());
			  _loc4_.writeInt(rest.shift());
		  }
		  sendPackage(_loc4_);
	  }
	  
	  public static function sendBringUpLockStatusUpdate(param1:int, param2:int, param3:Boolean) : void
	  {
		  var _loc4_:PackageOut = new PackageOut(ePackageType.ITEM_CELL_IS_LOCKED);
		  _loc4_.writeInt(param1);
		  _loc4_.writeInt(param2);
		  _loc4_.writeBoolean(param3);
		  sendPackage(_loc4_);
	  }
   }
}
