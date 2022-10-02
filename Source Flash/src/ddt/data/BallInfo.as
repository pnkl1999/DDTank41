package ddt.data
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.ModuleLoader;
   import ddt.manager.BallManager;
   import ddt.manager.PathManager;
   import flash.geom.Point;
   
   public class BallInfo
   {
       
      
      public var ID:int = 2;
      
      public var Name:String;
      
      public var Mass:Number = 1;
      
      public var Power:Number;
      
      public var Radii:Number;
      
      public var SpinV:Number = 1000;
      
      public var SpinVA:Number = 1;
      
      public var Amount:Number = 1;
      
      public var Wind:int;
      
      public var Weight:int;
      
      public var DragIndex:int;
      
      public var Shake:Boolean;
      
      public var ShootSound:String;
      
      public var BombSound:String;
      
      public var ActionType:int;
      
      public var blastOutID:int;
      
      public var craterID:int;
      
      public var FlyingPartical:int;
      
      public function BallInfo()
      {
         super();
      }
      
      public function getCarrayBall() : Point
      {
         return new Point(0,90);
      }
      
      public function loadBombAsset() : void
      {
         if(!ModuleLoader.hasDefinition(BallManager.solveBulletMovieName(this.ID)) && !ModuleLoader.hasDefinition(BallManager.solveShootMovieMovieName(this.ID)))
         {
            LoaderManager.Instance.creatAndStartLoad(PathManager.solveBlastOut(this.ID),BaseLoader.MODULE_LOADER);
         }
         if(!ModuleLoader.hasDefinition(BallManager.solveBlastOutMovieName(this.blastOutID)))
         {
            LoaderManager.Instance.creatAndStartLoad(PathManager.solveBullet(this.blastOutID),BaseLoader.MODULE_LOADER);
         }
      }
      
      public function loadCraterBitmap() : void
      {
         var _loc1_:BaseLoader = null;
         var _loc2_:BaseLoader = null;
         if(!BallManager.hasBombAsset(this.craterID))
         {
            if(this.craterID != 0)
            {
               _loc1_ = LoaderManager.Instance.creatLoader(PathManager.solveCrater(this.craterID),BaseLoader.BITMAP_LOADER);
               _loc1_.addEventListener(LoaderEvent.COMPLETE,this.__craterComplete);
               LoaderManager.Instance.startLoad(_loc1_);
               _loc2_ = LoaderManager.Instance.creatLoader(PathManager.solveCraterBrink(this.craterID),BaseLoader.BITMAP_LOADER);
               _loc2_.addEventListener(LoaderEvent.COMPLETE,this.__craterBrinkComplete);
               LoaderManager.Instance.startLoad(_loc2_);
            }
         }
      }
      
      private function __craterComplete(param1:LoaderEvent) : void
      {
         (param1.currentTarget as BaseLoader).removeEventListener(LoaderEvent.COMPLETE,this.__craterComplete);
         BallManager.addBombAsset(this.craterID,param1.loader.content,BallManager.CRATER);
      }
      
      private function __craterBrinkComplete(param1:LoaderEvent) : void
      {
         (param1.currentTarget as BaseLoader).removeEventListener(LoaderEvent.COMPLETE,this.__craterBrinkComplete);
         BallManager.addBombAsset(this.craterID,param1.loader.content,BallManager.CREATER_BRINK);
      }
      
      public function isComplete() : Boolean
      {
         if(BallManager.hasBombAsset(this.craterID) && this.getHasDefinition(this))
         {
            return true;
         }
         if(this.craterID == 0 && this.getHasDefinition(this))
         {
            return true;
         }
         return false;
      }
      
      public function getHasDefinition(param1:BallInfo) : Boolean
      {
         if(!ModuleLoader.hasDefinition(BallManager.solveBlastOutMovieName(param1.blastOutID)))
         {
         }
         if(!ModuleLoader.hasDefinition(BallManager.solveBulletMovieName(param1.ID)))
         {
         }
         if(!ModuleLoader.hasDefinition(BallManager.solveShootMovieMovieName(param1.ID)))
         {
         }
         return ModuleLoader.hasDefinition(BallManager.solveBlastOutMovieName(param1.blastOutID)) && ModuleLoader.hasDefinition(BallManager.solveBulletMovieName(param1.ID));
      }
   }
}
