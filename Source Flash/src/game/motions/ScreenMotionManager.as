package game.motions
{
   import road7th.data.DictionaryData;
   
   public class ScreenMotionManager
   {
       
      
      private var _motions:DictionaryData;
      
      public function ScreenMotionManager()
      {
         super();
      }
      
      public function addMotion(param1:BaseMotionFunc) : void
      {
      }
      
      public function removeMotion(param1:BaseMotionFunc) : void
      {
      }
      
      public function execute() : void
      {
         var _loc1_:BaseMotionFunc = null;
         for each(_loc1_ in this._motions)
         {
            _loc1_.getResult();
         }
      }
   }
}
