package game.model
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.utils.StringUtils;
   import ddt.manager.LoadBombManager;
   import ddt.manager.PathManager;
   
   public class GameNeedMovieInfo
   {
       
      
      public var type:int;
      
      public var path:String;
      
      public var classPath:String;
      
      public var bombId:int;
      
      public function GameNeedMovieInfo()
      {
         super();
      }
      
      public function get filePath() : String
      {
         var _loc1_:String = "";
         if(this.type == 2)
         {
            _loc1_ = PathManager.SITE_MAIN;
         }
         return _loc1_ + this.path;
      }
      
      public function startBomb() : void
      {
         var _loc1_:String = this.classPath.replace("tank.resource.bombs.Bomb","");
         this.bombId = int(_loc1_);
         LoadBombManager.Instance.loadLivingBomb(this.bombId);
      }
      
      public function startLoad() : void
      {
         if(StringUtils.endsWith(this.filePath.toLocaleLowerCase(),"jpg") || StringUtils.endsWith(this.filePath.toLocaleLowerCase(),"png"))
         {
            LoaderManager.Instance.creatAndStartLoad(this.filePath,BaseLoader.BITMAP_LOADER);
         }
         else
         {
            if(this.type == 2)
            {
               LoaderManager.Instance.creatAndStartLoad(this.filePath,BaseLoader.MODULE_LOADER);
            }
            if(this.type == 1)
            {
               this.startBomb();
            }
         }
      }
   }
}
