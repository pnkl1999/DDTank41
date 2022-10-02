package trainer.controller
{
   public class NewHandGuideManager
   {
      
      private static const CUSTOM_PROGRESS:int = 0;
      
      private static var _instance:NewHandGuideManager;
       
      
      private var _progress:int;
      
      private var _mapID:int;
      
      public function NewHandGuideManager(param1:NewHandGuideManagerEnforcer)
      {
         super();
         this.initData();
      }
      
      public static function get Instance() : NewHandGuideManager
      {
         if(!_instance)
         {
            _instance = new NewHandGuideManager(new NewHandGuideManagerEnforcer());
         }
         return _instance;
      }
      
      public function get progress() : int
      {
         return this._progress;
      }
      
      public function set progress(param1:int) : void
      {
         if(param1 <= this._progress)
         {
            return;
         }
         this._progress = param1;
      }
      
      public function get mapID() : int
      {
         return this._mapID;
      }
      
      public function set mapID(param1:int) : void
      {
         this._mapID = param1;
      }
      
      private function initData() : void
      {
         if(CUSTOM_PROGRESS > 0)
         {
            this._progress = CUSTOM_PROGRESS;
         }
      }
      
      public function hasShowEnergyMsg() : Boolean
      {
         return this.mapID != 111;
      }
      
      public function isNewHandFB() : Boolean
      {
         if(this.mapID == 111 || this.mapID == 112 || this.mapID == 113 || this.mapID == 114 || this.mapID == 115 || this.mapID == 116)
         {
            return true;
         }
         return false;
      }
   }
}

class NewHandGuideManagerEnforcer
{
    
   
   function NewHandGuideManagerEnforcer()
   {
      super();
   }
}
