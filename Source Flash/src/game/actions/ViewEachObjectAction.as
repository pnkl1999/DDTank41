package game.actions
{
   import game.view.map.MapView;
   
   public class ViewEachObjectAction extends BaseAction
   {
       
      
      private var _map:MapView;
      
      private var _objects:Array;
      
      private var _interval:Number;
      
      private var _index:int;
      
      private var _count:int;
      
      private var _type:int;
      
      public function ViewEachObjectAction(param1:MapView, param2:Array, param3:int = 0, param4:Number = 1500)
      {
         super();
         this._objects = param2;
         this._map = param1;
         this._interval = param4 / 40;
         this._index = 0;
         this._count = 0;
         this._type = param3;
      }
      
      override public function execute() : void
      {
         if(this._count <= 0)
         {
            if(this._index < this._objects.length)
            {
               this._map.scenarioSetCenter(this._objects[this._index].x,this._objects[this._index].y,this._type);
               this._count = this._interval;
               ++this._index;
            }
            else
            {
               _isFinished = true;
            }
         }
         --this._count;
      }
   }
}
