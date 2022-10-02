package littleGame.model
{
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.ddt_internal;
   import ddt.interfaces.IProcessObject;
   import ddt.manager.ProcessManager;
   import flash.display.BitmapData;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import littleGame.LittleGameLoader;
   import littleGame.clock.Clock;
   import littleGame.data.Grid;
   import littleGame.data.Node;
   import littleGame.events.LittleGameEvent;
   import littleGame.events.LittleLivingEvent;
   import littleGame.interfaces.ILittleObject;
   import littleGame.view.ScoreShape;
   
   [Event(name="selfInhaledChanged",type="littleGame.events.LittleGameEvent")]
   [Event(name="soundEnabledChanged",type="littleGame.events.LittleGameEvent")]
   [Event(name="addLiving",type="littleGame.events.LittleGameEvent")]
   [Event(name="removeLiving",type="littleGame.events.LittleGameEvent")]
   [Event(name="update",type="littleGame.events.LittleGameEvent")]
   public class Scenario extends EventDispatcher implements IProcessObject
   {
       
      
      public var localStartTime:int;
      
      public var startTimestamp:int;
      
      public var grid:Grid;
      
      public var id:int;
      
      public var worldID:int;
      
      public var monsters:String;
      
      public var objects:String = "object/other.swf";
      
      private var _objects:Dictionary;
      
      private var _livings:Dictionary;
      
      private var _livingCount:int = 0;
      
      private var _onProcess:Boolean;
      
      private var _pause:Boolean = false;
      
      private var _stones:Vector.<Rectangle>;
      
      private var _selfPlayer:LittleSelf;
      
      private var _numDic:Dictionary;
      
      public var clock:Clock;
      
      public var delay:int;
      
      ddt_internal var bigNum:BitmapData;
      
      ddt_internal var normalNum:BitmapData;
      
      ddt_internal var markBack:BitmapData;
      
      ddt_internal var priceBack:BitmapData;
      
      ddt_internal var priceNum:BitmapData;
      
      ddt_internal var inhaleNeed:BitmapData;
      
      public var serverClock:int;
      
      public var gameLoader:LittleGameLoader;
      
      public var music:String;
      
      public var virtualTime:int = 0;
      
      private var _last:int = 0;
      
      private var _soundEnabled:Boolean;
      
      private var _selfInhaled:Boolean;
      
      public function Scenario()
      {
         this._objects = new Dictionary();
         this._livings = new Dictionary();
         this._stones = new Vector.<Rectangle>();
         this._numDic = new Dictionary();
         this.clock = new Clock();
         super();
      }
      
      private function __clock(event:TimerEvent) : void
      {
      }
      
      ddt_internal function drawNum() : void
      {
         ddt_internal::inhaleNeed = ClassUtils.CreatInstance("asset.littleGame.InhaleNeed");
         ddt_internal::priceBack = ClassUtils.CreatInstance("asset.littleGame.price");
         ddt_internal::priceNum = ClassUtils.CreatInstance("asset.littleGame.numprice");
         ddt_internal::markBack = ClassUtils.CreatInstance("asset.littleGame.Mark");
         ddt_internal::bigNum = ClassUtils.CreatInstance("asset.littleGame.num");
         var s:Number = ScoreShape.ddt_internal::size / ddt_internal::bigNum.height;
         var mat:Matrix = new Matrix();
         mat.scale(s,s);
         ddt_internal::normalNum = new BitmapData(ddt_internal::bigNum.width * s,ddt_internal::bigNum.height * s,true,0);
         ddt_internal::normalNum.draw(ddt_internal::bigNum,mat,null,null,null,true);
      }
      
      public function get stones() : Vector.<Rectangle>
      {
         return this._stones;
      }
      
      public function addObject(object:ILittleObject) : ILittleObject
      {
         this._objects[object.id] = object;
         return object;
      }
      
      public function removeObject(object:ILittleObject) : ILittleObject
      {
         if(object == null)
         {
            return null;
         }
         delete this._objects[object.id];
         ObjectUtils.disposeObject(object);
         return object;
      }
      
      public function addLiving(living:LittleLiving) : LittleLiving
      {
         var node:Node = null;
         if(this._livings[living.id] == null)
         {
            this._livings[living.id] = living;
            living.inGame = true;
            if(living.isSelf)
            {
               this.setSelfPlayer(living as LittleSelf);
            }
            living.speed = this.grid.cellSize;
            node = this.grid.getNode(living.pos.x,living.pos.y);
            ++this._livingCount;
            if(this.running)
            {
               dispatchEvent(new LittleGameEvent(LittleGameEvent.AddLiving,living));
            }
         }
         return living;
      }
      
      public function removeLiving(living:LittleLiving) : LittleLiving
      {
         var node:Node = null;
         if(living && !living.dieing && this._livings[living.id] != null)
         {
            delete this._livings[living.id];
            living.inGame = false;
            node = this.grid.getNode(living.pos.x,living.pos.y);
            --this._livingCount;
            dispatchEvent(new LittleGameEvent(LittleGameEvent.RemoveLiving,living));
         }
         return living;
      }
      
      public function get livings() : Dictionary
      {
         return this._livings;
      }
      
      public function findObject(id:int) : ILittleObject
      {
         return this._objects[id] as ILittleObject;
      }
      
      public function get littleObjects() : Dictionary
      {
         return this._objects;
      }
      
      public function findLiving(id:int) : LittleLiving
      {
         return this._livings[id] as LittleLiving;
      }
      
      public function get running() : Boolean
      {
         return this._onProcess;
      }
      
      private function creat() : void
      {
         this._stones.push(new Rectangle(654,20,80,200));
      }
      
      public function setSelfPlayer(self:LittleSelf) : void
      {
         this._selfPlayer = self;
      }
      
      private function __selfCollided(event:LittleLivingEvent) : void
      {
      }
      
      public function get selfPlayer() : LittleSelf
      {
         return this._selfPlayer;
      }
      
      public function startup() : void
      {
         ProcessManager.Instance.addObject(this);
      }
      
      public function shutdown() : void
      {
         ProcessManager.Instance.removeObject(this);
      }
      
      public function pause() : void
      {
         this._pause = true;
      }
      
      public function resume() : void
      {
         this._pause = false;
      }
      
      public function dispose() : void
      {
         var key:* = null;
         var key2:* = null;
         var living:LittleLiving = null;
         var object:ILittleObject = null;
         ObjectUtils.disposeObject(ddt_internal::inhaleNeed);
         ddt_internal::inhaleNeed = null;
         ObjectUtils.disposeObject(ddt_internal::priceNum);
         ddt_internal::priceNum = null;
         ObjectUtils.disposeObject(ddt_internal::priceBack);
         ddt_internal::priceBack = null;
         ObjectUtils.disposeObject(ddt_internal::markBack);
         ddt_internal::markBack = null;
         ObjectUtils.disposeObject(ddt_internal::bigNum);
         ddt_internal::bigNum = null;
         ObjectUtils.disposeObject(ddt_internal::normalNum);
         ddt_internal::normalNum = null;
         ObjectUtils.disposeObject(this.grid);
         this.grid = null;
         ProcessManager.Instance.removeObject(this);
         this.gameLoader.unload();
         this.gameLoader.dispose();
         for(key in this._livings)
         {
            living = this._livings[key];
            ObjectUtils.disposeObject(living);
            delete this._livings[key];
         }
         for(key2 in this._objects)
         {
            object = this._objects[key2];
            ObjectUtils.disposeObject(object);
            delete this._objects[key2];
         }
         this._livings = null;
         this._objects = null;
         this._selfPlayer = null;
         this.gameLoader = null;
      }
      
      public function get onProcess() : Boolean
      {
         return this._onProcess;
      }
      
      public function set onProcess(val:Boolean) : void
      {
         this._onProcess = val;
      }
      
      public function process(rate:Number) : void
      {
         var living:LittleLiving = null;
         if(this._pause)
         {
            return;
         }
         dispatchEvent(new LittleGameEvent(LittleGameEvent.Update));
         for each(living in this._livings)
         {
            living.update();
         }
      }
      
      public function get soundEnabled() : Boolean
      {
         return this._soundEnabled;
      }
      
      public function set soundEnabled(value:Boolean) : void
      {
         if(this._soundEnabled == value)
         {
            return;
         }
         this._soundEnabled = value;
         dispatchEvent(new LittleGameEvent(LittleGameEvent.SoundEnabledChanged));
      }
      
      public function get selfInhaled() : Boolean
      {
         return this._selfInhaled;
      }
      
      public function set selfInhaled(value:Boolean) : void
      {
         if(this._selfInhaled == value)
         {
            return;
         }
         this._selfInhaled = value;
         dispatchEvent(new LittleGameEvent(LittleGameEvent.SelfInhaleChanged));
      }
   }
}
