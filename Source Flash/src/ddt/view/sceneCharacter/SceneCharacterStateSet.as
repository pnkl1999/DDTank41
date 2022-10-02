package ddt.view.sceneCharacter
{
   public class SceneCharacterStateSet
   {
       
      
      private var _dataSet:Vector.<SceneCharacterStateItem>;
      
      public function SceneCharacterStateSet()
      {
         super();
         this._dataSet = new Vector.<SceneCharacterStateItem>();
      }
      
      public function push(param1:SceneCharacterStateItem) : void
      {
         if(!param1)
         {
            return;
         }
         param1.update();
         this._dataSet.push(param1);
      }
      
      public function get length() : uint
      {
         return this._dataSet.length;
      }
      
      public function get dataSet() : Vector.<SceneCharacterStateItem>
      {
         return this._dataSet;
      }
      
      public function getItem(param1:String) : SceneCharacterStateItem
      {
         var _loc2_:int = 0;
         if(this._dataSet && this._dataSet.length > 0)
         {
            _loc2_ = 0;
            while(_loc2_ < this._dataSet.length)
            {
               if(this._dataSet[_loc2_].type == param1)
               {
                  return this._dataSet[_loc2_];
               }
               _loc2_++;
            }
         }
         return null;
      }
      
      public function dispose() : void
      {
         while(this._dataSet && this._dataSet.length > 0)
         {
            this._dataSet[0].dispose();
            this._dataSet.shift();
         }
         this._dataSet = null;
      }
   }
}
