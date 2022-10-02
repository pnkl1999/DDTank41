package littleGame.actions
{
   import littleGame.LittleGameManager;
   import littleGame.data.Grid;
   import littleGame.model.LittleLiving;
   import littleGame.model.LittlePlayer;
   import littleGame.model.LittleSelf;
   import littleGame.model.Scenario;
   import road7th.comm.PackageIn;
   
   public class InhaleAction extends LittleLivingMoveAction
   {
       
      
      private var _life:int = 0;
      
      private var _lifeTime:int = 0;
      
      private var _x:int;
      
      private var _y:int;
      
      private var _dx:int;
      
      private var _dy:int;
      
      private var _endAction:String;
      
      private var _direction:String;
      
      private var _headType:int;
      
      public function InhaleAction()
      {
         super(null,null,null);
      }
      
      override public function parsePackege(scene:Scenario, pkg:PackageIn = null) : void
      {
         var id:int = 0;
         _scene = scene;
         _grid = _scene != null ? _scene.grid : null;
         id = pkg.readInt();
         this._endAction = pkg.readUTF();
         this._direction = pkg.readUTF();
         this._life = pkg.readInt();
         this._dx = pkg.readInt();
         this._dy = pkg.readInt();
         _living = _scene != null ? _scene.findLiving(id) : null;
         if(_living != null)
         {
            _living.act(this);
            if(_living)
            {
               _living.dx = this._dx;
               _living.dy = this._dy;
            }
         }
      }
      
      override public function prepare() : void
      {
         if(_living)
         {
            _path = LittleGameManager.Instance.fillPath(_living,_grid,_living.pos.x,_living.pos.y,this._dx,this._dy);
            _living.dx = this._dx;
            _living.dy = this._dy;
            if(_path == null)
            {
               this.finish();
            }
            else
            {
               _living.MotionState = 1;
               if(_living.isSelf)
               {
                  LittleSelf(_living).inhaled = true;
               }
            }
         }
         this._headType = Math.random() * 10000 % 3;
         super.prepare();
      }
      
      public function toString() : String
      {
         return "[InhaleAction_" + _living + ":(dx:" + this._dx + ";dy:" + this._dy + ";len:" + (_path == null ? "" : _path.length) + ";life:" + this._life + ";endAction:" + this._endAction + ")]";
      }
      
      override public function execute() : void
      {
         if(_living && _living.lock)
         {
            this.finish();
         }
         else if(_living && this._life > 0)
         {
            _living.direction = this._direction;
            if(_living.isPlayer)
            {
               LittlePlayer(_living).headType = this._headType;
            }
            _living.doAction(this._endAction);
            ++this._lifeTime;
            if(this._lifeTime >= this._life)
            {
               this.finish();
            }
         }
         else if(_living)
         {
            super.execute();
         }
      }
      
      override protected function finish() : void
      {
         _isFinished = true;
         if(this._life > 0)
         {
            _living.MotionState = 2;
            _living.doAction("stand");
         }
         else
         {
            _living.direction = this._direction;
            if(_living.isPlayer)
            {
               LittlePlayer(_living).headType = this._headType;
            }
            _living.doAction(this._endAction);
         }
         _living = null;
      }
   }
}
