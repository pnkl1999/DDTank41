package ddt.manager
{
   import ddt.data.BallInfo;
   import flash.utils.Dictionary;
   import room.model.RoomPlayer;
   import room.model.WeaponInfo;
   
   public class LoadBombManager
   {
      
      public static const SpecialBomb:Array = [1,3,4,64,59,97,98];
      
      private static var _instance:LoadBombManager;
       
      
      private var _tempWeaponInfos:Dictionary;
      
      private var _tempCraterIDs:Dictionary;
      
      public function LoadBombManager()
      {
         super();
      }
      
      public static function get Instance() : LoadBombManager
      {
         if(_instance == null)
         {
            _instance = new LoadBombManager();
         }
         return _instance;
      }
      
      public function loadFullRoomPlayersBomb(param1:Array) : void
      {
         this.loadFullWeaponBombMovie(param1);
         this.loadFullWeaponBombBitMap(param1);
      }
      
      private function loadFullWeaponBombMovie(param1:Array) : void
      {
         var _loc2_:RoomPlayer = null;
         var _loc3_:WeaponInfo = null;
         this._tempWeaponInfos = null;
         this._tempWeaponInfos = new Dictionary();
         for each(_loc2_ in param1)
         {
            if(!_loc2_.isViewer && !this._tempWeaponInfos[_loc2_.currentWeapInfo.TemplateID])
            {
               this._tempWeaponInfos[_loc2_.currentWeapInfo.TemplateID] = _loc2_.currentWeapInfo;
            }
         }
         for each(_loc3_ in this._tempWeaponInfos)
         {
            this.loadBomb(_loc3_);
         }
      }
      
      private function loadFullWeaponBombBitMap(param1:Array) : void
      {
         var _loc2_:WeaponInfo = null;
         var _loc3_:BallInfo = null;
         var _loc4_:int = 0;
         this._tempCraterIDs = null;
         this._tempCraterIDs = new Dictionary();
         for each(_loc2_ in this._tempWeaponInfos)
         {
            _loc4_ = 0;
            while(_loc4_ < _loc2_.bombs.length)
            {
               if(!this._tempCraterIDs[BallManager.findBall(_loc2_.bombs[_loc4_]).craterID])
               {
                  this._tempCraterIDs[BallManager.findBall(_loc2_.bombs[_loc4_]).craterID] = BallManager.findBall(_loc2_.bombs[_loc4_]);
               }
               _loc4_++;
            }
         }
         for each(_loc3_ in this._tempCraterIDs)
         {
            _loc3_.loadCraterBitmap();
         }
      }
      
      private function loadBomb(param1:WeaponInfo) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.bombs.length)
         {
            BallManager.findBall(param1.bombs[_loc2_]).loadBombAsset();
            _loc2_++;
         }
      }
      
      public function getLoadBombComplete(param1:WeaponInfo) : Boolean
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.bombs.length)
         {
            if(!BallManager.findBall(param1.bombs[_loc2_]).isComplete())
            {
               return false;
            }
            _loc2_++;
         }
         return true;
      }
      
      public function getUnloadedBombString(param1:WeaponInfo) : String
      {
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < SpecialBomb.length)
         {
            if(!BallManager.findBall(param1.bombs[_loc3_]).isComplete())
            {
               _loc2_ += SpecialBomb[_loc3_] + ",";
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function loadLivingBomb(param1:int) : void
      {
         BallManager.findBall(param1).loadBombAsset();
         BallManager.findBall(param1).loadCraterBitmap();
      }
      
      public function getLivingBombComplete(param1:int) : Boolean
      {
         return BallManager.findBall(param1).isComplete();
      }
      
      public function loadSpecialBomb() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < SpecialBomb.length)
         {
            BallManager.findBall(SpecialBomb[_loc1_]).loadBombAsset();
            BallManager.findBall(SpecialBomb[_loc1_]).loadCraterBitmap();
            _loc1_++;
         }
      }
      
      public function getUnloadedSpecialBombString() : String
      {
         var _loc1_:String = "";
         var _loc2_:int = 0;
         while(_loc2_ < SpecialBomb.length)
         {
            if(!BallManager.findBall(SpecialBomb[_loc2_]).isComplete())
            {
               _loc1_ += SpecialBomb[_loc2_] + ",";
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function getLoadSpecialBombComplete() : Boolean
      {
         var _loc1_:int = 0;
         while(_loc1_ < SpecialBomb.length)
         {
            if(!BallManager.findBall(SpecialBomb[_loc1_]).isComplete())
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
   }
}
