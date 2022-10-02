package ddt.manager
{
   import com.pickgliss.utils.ClassUtils;
   import ddt.data.BallInfo;
   import ddt.data.analyze.BallInfoAnalyzer;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import game.objects.BombAsset;
   
   public class BallManager
   {
      
      private static var _list:Vector.<BallInfo>;
      
      private static var _gameInBombAssets:Dictionary;
      
      public static const CRATER:int = 0;
      
      public static const CREATER_BRINK:int = 1;
       
      
      public function BallManager()
      {
         super();
      }
      
      public static function setup(param1:BallInfoAnalyzer) : void
      {
         _list = param1.list;
         _gameInBombAssets = new Dictionary();
      }
      
      public static function addBombAsset(param1:int, param2:Bitmap, param3:int) : void
      {
         if(_gameInBombAssets[param1] == null)
         {
            _gameInBombAssets[param1] = new BombAsset();
         }
         if(param3 == CRATER)
         {
            if(_gameInBombAssets[param1].crater == null)
            {
               _gameInBombAssets[param1].crater = param2;
            }
         }
         else if(param3 == CREATER_BRINK)
         {
            if(_gameInBombAssets[param1].craterBrink == null)
            {
               _gameInBombAssets[param1].craterBrink = param2;
            }
         }
      }
      
      public static function hasBombAsset(param1:int) : Boolean
      {
         return _gameInBombAssets[param1] != null;
      }
      
      public static function getBombAsset(param1:int) : BombAsset
      {
         return _gameInBombAssets[param1];
      }
      
      public static function get ready() : Boolean
      {
         return _list != null;
      }
      
      public static function findBall(param1:int) : BallInfo
      {
         var _loc2_:BallInfo = null;
         var _loc3_:BallInfo = null;
         for each(_loc3_ in _list)
         {
            if(_loc3_.ID == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         return _loc2_;
      }
      
      public static function solveBallAssetName(param1:int) : String
      {
         return "tank.resource.bombs.Bomb" + param1;
      }
      
      public static function solveBallWeaponMovieName(param1:int) : String
      {
         return "tank.resource.bombs.BombMovie" + param1;
      }
      
      public static function createBallWeaponMovie(param1:int) : MovieClip
      {
         return ClassUtils.CreatInstance(solveBallWeaponMovieName(param1)) as MovieClip;
      }
      
      public static function createBallAsset(param1:int) : Sprite
      {
         return ClassUtils.CreatInstance(solveBallAssetName(param1)) as Sprite;
      }
      
      public static function solveBlastOutMovieName(param1:int) : String
      {
         return "blastOutMovie" + param1;
      }
      
      public static function solveBulletMovieName(param1:int) : String
      {
         return "bullet" + param1;
      }
      
      public static function solveShootMovieMovieName(param1:int) : String
      {
         return "shootMovie" + param1;
      }
      
      public static function createBlastOutMovie(param1:int) : MovieClip
      {
         return ClassUtils.CreatInstance(solveBlastOutMovieName(param1)) as MovieClip;
      }
      
      public static function createBulletMovie(param1:int) : MovieClip
      {
         return ClassUtils.CreatInstance(solveBulletMovieName(param1)) as MovieClip;
      }
      
      public static function createShootMovieMovie(param1:int) : MovieClip
      {
         return ClassUtils.CreatInstance(solveShootMovieMovieName(param1)) as MovieClip;
      }
      
      public static function clearAsset() : void
      {
         var _loc1_:* = null;
         for(_loc1_ in _gameInBombAssets)
         {
            _gameInBombAssets[_loc1_].dispose();
            delete _gameInBombAssets[_loc1_];
         }
      }
   }
}
