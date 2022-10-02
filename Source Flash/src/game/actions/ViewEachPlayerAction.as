package game.actions
{
   import game.GameManager;
   import game.view.map.MapView;
   
   public class ViewEachPlayerAction extends BaseAction
   {
       
      
      private var _map:MapView;
      
      private var _players:Array;
      
      private var _interval:Number;
      
      private var _index:int;
      
      private var _count:int;
      
      public function ViewEachPlayerAction(param1:MapView, param2:Array, param3:Number = 1500)
      {
         super();
         this._players = param2.sortOn("x",Array.NUMERIC);
         this._map = param1;
         this._interval = param3 / 40;
         this._index = 0;
         this._count = 0;
      }
      
      override public function execute() : void
      {
         if(GameManager.Instance.Current == null)
         {
            return;
         }
         if(this._count <= 0)
         {
            if(this._index < this._players.length)
            {
               this._map.setCenter(this._players[this._index].x,this._players[this._index].y - 150,true);
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
