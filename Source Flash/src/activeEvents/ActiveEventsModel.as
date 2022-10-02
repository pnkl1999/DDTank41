package activeEvents
{
   import activeEvents.data.ActiveEventsInfo;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   
   public class ActiveEventsModel extends EventDispatcher
   {
      
      public static var newMovement:Dictionary = new Dictionary();
       
      
      private var _list:Array;
      
      private var _activesList:Array;
      
      public function ActiveEventsModel()
      {
         super();
      }
      
      public function get actives() : Array
      {
         return this._activesList;
      }
      
      public function get list() : Array
      {
         return this._list;
      }
      
      public function set actives(param1:Array) : void
      {
         this._list = param1;
         this._activesList = this._list.concat();
         this.filtTime();
         this._activesList = this.sortActives();
      }
      
      private function filtTime() : void
      {
         var _loc2_:ActiveEventsInfo = null;
         var _loc1_:int = this.actives.length - 1;
         while(_loc1_ >= 0)
         {
            _loc2_ = this.actives[_loc1_];
            if(_loc2_.overdue())
            {
               this.actives.splice(_loc1_,1);
            }
            _loc1_--;
         }
      }
      
      private function sortActives() : Array
      {
         var _loc5_:ActiveEventsInfo = null;
         var _loc1_:Array = new Array();
         var _loc2_:Array = new Array();
         var _loc3_:Array = new Array();
         var _loc4_:int = 0;
         while(_loc4_ < this.actives.length)
         {
            _loc5_ = this.actives[_loc4_];
            if(_loc5_.Type == 0)
            {
               _loc3_.push(_loc5_);
            }
            else if(_loc5_.Type == 1)
            {
               _loc2_.push(_loc5_);
               if(newMovement[_loc5_.ActiveID] == null)
               {
                  newMovement[_loc5_.ActiveID] = false;
               }
            }
            else if(_loc5_.Type == 2)
            {
               _loc1_.push(_loc5_);
            }
            _loc4_++;
         }
         return _loc1_.concat(_loc2_,_loc3_);
      }
   }
}
