package littleGame.actions
{
   import ddt.ddt_internal;
   import flash.geom.Point;
   import flash.utils.getTimer;
   import littleGame.LittleGameManager;
   import littleGame.data.Grid;
   import littleGame.data.Node;
   import littleGame.model.LittleSelf;
   import littleGame.model.Scenario;
   
   use namespace ddt_internal;
   
   public class LittleSelfMoveAction extends LittleAction
   {
       
      
      private var _self:LittleSelf;
      
      private var _path:Array;
      
      private var _grid:Grid;
      
      private var _idx:int = 0;
      
      private var _elapsed:int = 0;
      
      private var _last:int;
      
      private var _startTime:int;
      
      private var _endTime:int;
      
      private var _scene:Scenario;
      
      private var _len:int;
      
      private var _reset:Boolean;
      
      public function LittleSelfMoveAction(self:LittleSelf, path:Array, scene:Scenario, startTime:int, endTime:int, reset:Boolean = false)
      {
         this._scene = scene;
         _living = this._self = self;
         this._path = path;
         this._grid = this._scene.grid;
         this._startTime = startTime;
         this._endTime = endTime;
         this._len = this._path.length;
         this._reset = reset;
         super();
      }
      
      override public function connect(action:LittleAction) : Boolean
      {
         var act:LittleSelfMoveAction = null;
         if(action is InhaleAction)
         {
            this.cancel();
            return false;
         }
         if(action is LittleSelfMoveAction)
         {
            act = action as LittleSelfMoveAction;
            this._scene = act._scene;
            this._self = act._self;
            this._path = act._path;
            this._grid = act._grid;
            this._startTime = act._startTime;
            this._len = act._len;
            this._idx = 0;
            return true;
         }
         return false;
      }
      
      override public function prepare() : void
      {
         var node:Node = this._path[0];
         var nextPos:Point = new Point(node.x,node.y);
         this._self.setNextDirection(nextPos);
         this._self.pos = nextPos;
         super.prepare();
         this._last = getTimer();
      }
      
      override public function execute() : void
      {
         var node:Node = null;
         var nextPos:Point = null;
         if(this._idx < this._path.length)
         {
            node = this._path[this._idx++];
            if(node)
            {
               nextPos = new Point(node.x,node.y);
               this._self.setNextDirection(nextPos);
               this._self.pos = nextPos;
            }
         }
         else
         {
            this.finish();
         }
      }
      
      override protected function finish() : void
      {
         if(this._self.isBack)
         {
            this._self.doAction("backStand");
         }
         else
         {
            this._self.doAction("stand");
         }
         this.synchronous();
         super.finish();
      }
      
      private function synchronous() : void
      {
         LittleGameManager.Instance.synchronousLivingPos(this._self.pos.x,this._self.pos.y);
      }
      
      override public function cancel() : void
      {
         _isFinished = true;
         _living = null;
      }
   }
}
