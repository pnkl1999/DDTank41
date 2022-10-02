package ddt.view.sceneCharacter
{
   public class SceneCharacterSet
   {
       
      
      private var _dataSet:Vector.<SceneCharacterItem>;
      
      public function SceneCharacterSet()
      {
         super();
         this._dataSet = new Vector.<SceneCharacterItem>();
      }
      
      public function push(param1:SceneCharacterItem) : void
      {
         this._dataSet.push(param1);
      }
      
      public function get length() : uint
      {
         return this._dataSet.length;
      }
      
      public function get dataSet() : Vector.<SceneCharacterItem>
      {
         return this._dataSet.sort(this.sortOn);
      }
      
      private function sortOn(param1:SceneCharacterItem, param2:SceneCharacterItem) : Number
      {
         if(param1.sortOrder < param2.sortOrder)
         {
            return -1;
         }
         if(param1.sortOrder > param2.sortOrder)
         {
            return 1;
         }
         return 0;
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
