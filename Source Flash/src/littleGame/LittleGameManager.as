package littleGame
{
   import ddt.data.player.PlayerInfo;
   import ddt.data.socket.ePackageType;
   import ddt.ddt_internal;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.display.DisplayObjectContainer;
   import flash.events.EventDispatcher;
   import littleGame.actions.LittleAction;
   import littleGame.actions.LittleLivingDieAction;
   import littleGame.actions.LittleLivingMoveAction;
   import littleGame.actions.LittleSelfMoveAction;
   import littleGame.data.Grid;
   import littleGame.data.LittleGamePackageOutType;
   import littleGame.data.Node;
   import littleGame.events.LittleGameEvent;
   import littleGame.interfaces.ILittleObject;
   import littleGame.model.LittleLiving;
   import littleGame.model.LittlePlayer;
   import littleGame.model.LittleSelf;
   import littleGame.model.Scenario;
   import littleGame.object.BoguGiveUp;
   import littleGame.object.NormalBoguInhaled;
   import littleGame.view.GameScene;
   import road7th.comm.PackageIn;
   import road7th.comm.PackageOut;
   
   use namespace ddt_internal;
   
   [Event(name="activedChanged",type="littleGame.events.LittleGameEvent")]
   public class LittleGameManager extends EventDispatcher
   {
      
      public static const Player:int = 1;
      
      public static const Living:int = 2;
      
      public static const GameBackLayer:int = 0;
      
      public static const GameForeLayer:int = 1;
      
      private static var _ins:LittleGameManager;
       
      
      private var _actived:Boolean = false;
      
      public var soundEnabled:Boolean = true;
      
      private var _current:Scenario;
      
      private var _mainStage:DisplayObjectContainer;
      
      private var _gamescene:GameScene;
      
      public function LittleGameManager()
      {
         super();
      }
      
      public static function get Instance() : LittleGameManager
      {
         return _ins = _ins || new LittleGameManager();
      }
      
      public function initialize() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LITTLEGAME_ACTIVED,this.__actived);
      }
      
      private function __actived(event:CrazyTankSocketEvent) : void
      {
         this._actived = event.pkg.readBoolean();
         dispatchEvent(new LittleGameEvent(LittleGameEvent.ActivedChanged));
      }
      
      public function hasActive() : Boolean
      {
         return this._actived;
      }
      
      public function hasCanStart(player:PlayerInfo) : Boolean
      {
         return player.Grade >= PathManager.LittleGameMinLv;
      }
      
      public function kickPlayer(pkg:PackageIn) : void
      {
         StateManager.setState(StateType.MAIN);
      }
      
      public function fillPath(living:LittleLiving, grid:Grid, startX:int, startY:int, endX:int, endY:int) : Array
      {
         if(living.isSelf && living.MotionState <= 1)
         {
            return null;
         }
         var end:Node = grid.getNode(endX,endY);
         if(end && end.walkable)
         {
            grid.setStartNode(startX,startY);
            grid.setEndNode(endX,endY);
            if(grid.fillPath())
            {
               return grid.path;
            }
            return null;
         }
         return null;
      }
      
      public function collide(self:LittleSelf, target:LittleLiving) : Boolean
      {
         return true;
      }
      
      public function enterWorld() : void
      {
         var pkg:PackageOut = this.createPackageOut();
         pkg.writeByte(LittleGamePackageOutType.ENTER_WORLD);
         this.sendPackage(pkg);
      }
      
      public function enterGame(scene:Scenario, pkg:PackageIn) : void
      {
         BoguGiveUp.NoteCount = 0;
         NormalBoguInhaled.NoteCount = 0;
         this._current = scene;
         this._current.drawNum();
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            scene.addLiving(this.readLivingFromPacket(pkg,scene));
         }
      }
      
      public function addObject(scene:Scenario, type:String, pkg:PackageIn = null) : ILittleObject
      {
         var object:ILittleObject = ObjectCreator.CreatObject(type);
         if(object)
         {
            object.initialize(scene,pkg);
            scene.addObject(object);
         }
         return object;
      }
      
      public function removeObject(scene:Scenario, pkg:PackageIn) : ILittleObject
      {
         var id:int = pkg.readInt();
         return scene.removeObject(scene.findObject(id));
      }
      
      public function invokeObject(scene:Scenario, pkg:PackageIn) : ILittleObject
      {
         var id:int = pkg.readInt();
         var obj:ILittleObject = scene.findObject(id);
         obj.invoke(pkg);
         return obj;
      }
      
      public function addLiving(scene:Scenario, pkg:PackageIn) : LittleLiving
      {
         return scene.addLiving(this.readLivingFromPacket(pkg,scene));
      }
      
      public function removeLiving(scene:Scenario, pkg:PackageIn) : LittleLiving
      {
         var livingID:int = pkg.readInt();
         var living:LittleLiving = scene.livings[livingID];
         if(living && !living.dieing)
         {
            scene.removeLiving(living);
         }
         return living;
      }
      
      public function livingDie(scene:Scenario, living:LittleLiving, lifetime:int = 6) : void
      {
         var act:LittleAction = new LittleLivingDieAction(scene,living,lifetime);
         living.act(act);
      }
      
      private function readLivingFromPacket(pkg:PackageIn, scene:Scenario = null) : LittleLiving
      {
         var living:LittleLiving = null;
         var playerInfo:PlayerInfo = null;
         var name:String = null;
         var modelID:String = null;
         var dx:int = 0;
         var dy:int = 0;
         var action:LittleAction = null;
         var id:int = pkg.readInt();
         var x:int = pkg.readInt();
         var y:int = pkg.readInt();
         var type:int = pkg.readInt();
         if(type == Player)
         {
            playerInfo = new PlayerInfo();
            playerInfo.ID = pkg.readInt();
            playerInfo.Grade = pkg.readInt();
            playerInfo.Repute = pkg.readInt();
            playerInfo.NickName = pkg.readUTF();
            playerInfo.typeVIP = pkg.readByte();
            playerInfo.VIPLevel = pkg.readInt();
            playerInfo.Sex = pkg.readBoolean();
            playerInfo.Style = pkg.readUTF();
            playerInfo.Colors = pkg.readUTF();
            playerInfo.Skin = pkg.readUTF();
            playerInfo.Hide = pkg.readInt();
            playerInfo.FightPower = pkg.readInt();
            playerInfo.WinCount = pkg.readInt();
            playerInfo.TotalCount = pkg.readInt();
            if(playerInfo.ID == PlayerManager.Instance.Self.ID)
            {
               living = new LittleSelf(PlayerManager.Instance.Self,id,x,y,type);
            }
            else
            {
               living = new LittlePlayer(playerInfo,id,x,y,type);
            }
         }
         else
         {
            name = pkg.readUTF();
            modelID = pkg.readUTF();
            living = new LittleLiving(id,x,y,type,modelID);
            living.name = name;
         }
         var isMove:Boolean = pkg.readBoolean();
         if(isMove)
         {
            dx = pkg.readInt();
            dy = pkg.readInt();
            if(scene)
            {
               this.fillPath(living,scene.grid,x,y,dx,dy);
            }
         }
         var actCount:int = pkg.readInt();
         for(var i:int = 0; i < actCount; i++)
         {
            action = this.doAction(scene,pkg);
            action.initializeLiving(living);
            living.act(action);
         }
         return living;
      }
      
      private function setLivingSize(living:LittleLiving, modelID:String) : void
      {
         if(modelID == "bogu4" || modelID == "bogu5" || modelID == "bogu8")
         {
            living.size = 1;
         }
         else if(modelID == "bogu6")
         {
            living.size = 2;
         }
         else if(modelID == "bogu7")
         {
            living.size = 3;
         }
      }
      
      public function updatePos(scene:Scenario, pkg:PackageIn) : void
      {
         var id:int = 0;
         var x:int = 0;
         var y:int = 0;
         var living:LittleLiving = null;
         pkg.readDouble();
         var count:int = pkg.readInt();
         for(var i:int = 0; i < count; i++)
         {
            id = pkg.readInt();
            x = pkg.readInt();
            y = pkg.readInt();
            living = scene.findLiving(id);
         }
      }
      
      public function livingMove(scene:Scenario, pkg:PackageIn) : LittleLiving
      {
         var path:Array = null;
         var id:int = pkg.readInt();
         var dx:int = pkg.readInt();
         var dy:int = pkg.readInt();
         var living:LittleLiving = scene.findLiving(id);
         if(living && !living.lock && !living.dieing && !living.borning && living.MotionState > 1)
         {
            path = LittleGameManager.Instance.fillPath(living,scene.grid,living.pos.x,living.pos.y,dx,dy);
            if(path)
            {
               if(!living.isSelf)
               {
                  living.act(new LittleLivingMoveAction(living,path,scene));
               }
            }
            return living;
         }
         return null;
      }
      
      public function selfMoveTo(scene:Scenario, self:LittleSelf, x:int, y:int, dx:int, dy:int, clock:int, path:Array) : void
      {
         self.act(new LittleSelfMoveAction(self,path,this._current,clock,clock + path.length * 40,true));
         var pkg:PackageOut = this.createPackageOut();
         pkg.writeByte(LittleGamePackageOutType.MOVE);
         pkg.writeInt(x);
         pkg.writeInt(y);
         pkg.writeInt(dx);
         pkg.writeInt(dy);
         pkg.writeInt(clock);
         this.sendPackage(pkg);
      }
      
      public function inhaled(self:LittleSelf) : void
      {
         self.inhaled = false;
      }
      
      public function updateLivingProperty(scene:Scenario, pkg:PackageIn) : void
      {
         var name:String = null;
         var type:int = 0;
         var val:* = undefined;
         var i:int = 0;
         var id:int = pkg.readInt();
         var count:int = pkg.readInt();
         var living:LittleLiving = scene.findLiving(id);
         if(living)
         {
            for(i = 0; i < count; i++)
            {
               name = pkg.readUTF();
               type = pkg.readInt();
               switch(type)
               {
                  case 1:
                     val = pkg.readInt();
                     break;
                  case 2:
                     val = pkg.readBoolean();
                     break;
                  case 3:
                     val = pkg.readUTF();
                     break;
                  default:
                     continue;
               }
               if(living.hasOwnProperty(name))
               {
                  living[name] = val;
               }
            }
         }
      }
      
      public function doAction(scene:Scenario, pkg:PackageIn) : LittleAction
      {
         var type:String = pkg.readUTF();
         var action:LittleAction = LittleActionCreator.CreatAction(type);
         if(action)
         {
            action.parsePackege(scene,pkg);
         }
         return action;
      }
      
      public function doMovie(scene:Scenario, pkg:PackageIn) : void
      {
         var id:int = pkg.readInt();
         var living:LittleLiving = scene.findLiving(id);
         var act:String = pkg.readUTF();
         if(living)
         {
         }
      }
      
      public function setClock(scene:Scenario, pkg:PackageIn) : void
      {
         var clock:int = pkg.readInt();
      }
      
      public function pong(scene:Scenario, pkg:PackageIn) : void
      {
         var timestamp:int = pkg.readInt();
         var pkgOut:PackageOut = this.createPackageOut();
         pkgOut.writeByte(LittleGamePackageOutType.PING);
         pkgOut.writeInt(timestamp);
         this.sendPackage(pkgOut);
      }
      
      public function ping(timestamp:int) : void
      {
         var pkg:PackageOut = this.createPackageOut();
         pkg.writeByte(LittleGamePackageOutType.PING);
         pkg.writeInt(timestamp);
         this.sendPackage(pkg);
      }
      
      public function setNetDelay(scene:Scenario, pkg:PackageIn) : void
      {
         var delay:int = pkg.readInt();
         scene.delay = delay;
         ChatManager.Instance.sysChatYellow("delay:" + delay);
      }
      
      public function getScore(scene:Scenario, pkg:PackageIn) : void
      {
         var score:int = pkg.readInt();
         scene.selfPlayer.getScore(score);
      }
      
      public function livingClick(scene:Scenario, living:LittleLiving, x:int, y:int) : void
      {
         var dx:int = 0;
         var dy:int = 0;
         var self:LittleSelf = null;
         var path:Array = null;
         var pkg:PackageOut = null;
         if(!living.isPlayer && !living.dieing)
         {
            dx = x / this._current.grid.cellSize;
            dy = y / this._current.grid.cellSize;
            self = this._current.selfPlayer;
            path = this.fillPath(self,this._current.grid,self.pos.x,self.pos.y,dx,dy);
            if(path)
            {
            }
            if(!living.borning && self.MotionState > 1)
            {
               pkg = this.createPackageOut();
               pkg.writeByte(LittleGamePackageOutType.CLICK);
               pkg.writeInt(living.id);
               pkg.writeInt(living.pos.x);
               pkg.writeInt(living.pos.y);
               pkg.writeInt(self.pos.x);
               pkg.writeInt(self.pos.y);
               this.sendPackage(pkg);
            }
         }
      }
      
      public function cancelInhaled(id:int) : void
      {
         var pkg:PackageOut = this.createPackageOut();
         pkg.writeByte(LittleGamePackageOutType.CANCEL_CLICK);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      public function synchronousLivingPos(x:int, y:int) : void
      {
         var pkg:PackageOut = this.createPackageOut();
         pkg.writeByte(LittleGamePackageOutType.POS_SYNC);
         pkg.writeInt(x);
         pkg.writeInt(y);
         this.sendPackage(pkg);
      }
      
      public function loadComplete() : void
      {
         var pkg:PackageOut = this.createPackageOut();
         pkg.writeByte(LittleGamePackageOutType.LOAD_COMPLETED);
         this.sendPackage(pkg);
      }
      
      public function createGame(pkg:PackageIn) : Scenario
      {
         var scene:Scenario = new Scenario();
         scene.worldID = pkg.readInt();
         scene.id = pkg.readInt();
         scene.monsters = pkg.readUTF();
         scene.music = pkg.readUTF();
         return scene;
      }
      
      public function leave() : void
      {
         var pkg:PackageOut = this.createPackageOut();
         pkg.writeByte(LittleGamePackageOutType.LEAVE_WORLD);
         this.sendPackage(pkg);
         StateManager.setState(StateType.LITTLEHALL);
         LittleGamePacketQueue.Instance.shutdown();
      }
      
      public function get Current() : Scenario
      {
         return this._current;
      }
      
      public function sendScore(score:int, id:int) : void
      {
         var pkg:PackageOut = this.createPackageOut();
         pkg.writeByte(LittleGamePackageOutType.REPORT_SCORE);
         pkg.writeInt(score);
         pkg.writeInt(id);
         this.sendPackage(pkg);
      }
      
      private function createPackageOut() : PackageOut
      {
         return new PackageOut(ePackageType.LITTLEGAME_COMMAND);
      }
      
      public function sendPackage(pkg:PackageOut) : void
      {
         SocketManager.Instance.out.sendPackage(pkg);
      }
      
      public function setMainStage(val:DisplayObjectContainer) : void
      {
         this._mainStage = val;
      }
      
      public function setGameScene(val:GameScene) : void
      {
         this._gamescene = val;
      }
      
      public function get gameScene() : GameScene
      {
         return this._gamescene;
      }
      
      public function get mainStage() : DisplayObjectContainer
      {
         return this._mainStage;
      }
   }
}
