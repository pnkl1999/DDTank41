package littleGame.actions
{
   import ddt.ddt_internal;
   import flash.geom.Point;
   import littleGame.data.Grid;
   import littleGame.data.Node;
   import littleGame.model.LittleLiving;
   import littleGame.model.Scenario;
   
   use namespace ddt_internal;
   
   public class LittleLivingMoveAction extends LittleAction
   {
       
      
      protected var _path:Array;
      
      protected var _grid:Grid;
      
      protected var _idx:int = 0;
      
      protected var _scene:Scenario;
      
      protected var _len:int;
      
      protected var _totalTime:int;
      
      protected var _elapsed:int;
      
      public function LittleLivingMoveAction(living:LittleLiving, path:Array, scene:Scenario)
      {
         this._scene = scene;
         _living = living;
         this._path = path;
         this._grid = this._scene == null ? null : this._scene.grid;
         super();
      }
      
      override public function connect(action:LittleAction) : Boolean
      {
         var act:LittleLivingMoveAction = null;
         if(action is InhaleAction)
         {
            this.cancel();
            return false;
         }
         if(action is LittleLivingMoveAction)
         {
            act = action as LittleLivingMoveAction;
            this._scene = act._scene;
            _living = act._living;
            this._path = act._path;
            this._grid = act._grid;
            this._len = act._len;
            this._idx = 0;
            return true;
         }
         return false;
      }
      
      override public function prepare() : void
      {
         var node:Node = null;
         var nextPos:Point = null;
         if(this._path)
         {
            node = this._path[0];
            nextPos = new Point(node.x,node.y);
            if(_living)
            {
               _living.setNextDirection(nextPos);
               _living.pos = nextPos;
            }
         }
         super.prepare();
      }
      
      override public function execute() : void
      {
         var node:Node = null;
         var nextPos:Point = null;
         if(this._path && this._idx < this._path.length)
         {
            node = this._path[this._idx++];
            if(node)
            {
               nextPos = new Point(node.x,node.y);
               _living.setNextDirection(nextPos);
               _living.pos = nextPos;
            }
         }
         else
         {
            this.finish();
         }
      }
      
      override protected function finish() : void
      {
         var nextPos:Point = null;
         _living.doAction("stand");
         var node:Node = this._path[this._path.length - 1];
         if(node)
         {
            nextPos = new Point(node.x,node.y);
            _living.pos = nextPos;
         }
         _living = null;
         this._grid = null;
         this._scene = null;
         this._path = null;
         super.finish();
      }
      
      override public function cancel() : void
      {
         _isFinished = true;
         _living = null;
         this._grid = null;
         this._scene = null;
         this._path = null;
      }
   }
}
