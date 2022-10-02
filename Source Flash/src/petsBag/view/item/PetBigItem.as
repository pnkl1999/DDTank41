package petsBag.view.item
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PathManager;
   import ddt.utils.Helpers;
   import flash.display.Bitmap;
   import flash.utils.getTimer;
   import pet.date.PetInfo;
   import road.game.resource.ActionMovie;
   import road.game.resource.ActionMovieEvent;
   
   public class PetBigItem extends Component implements Disposeable
   {
       
      
      private var _petMovie:ActionMovie;
      
      private var _info:PetInfo;
      
      private var ACTIONS:Array;
      
      private var _fightImg:Bitmap;
      
      private var _loader:BaseLoader;
      
      private var _lastTime:uint = 0;
      
      public function PetBigItem()
      {
         this.ACTIONS = ["standA","walkA","walkB","hunger"];
         super();
      }
      
      public function initTips() : void
      {
         tipStyle = "petsBag.view.item.PetGrowUpTip";
         tipDirctions = "5,2,7,1,6,4";
      }
      
      public function set info(param1:PetInfo) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:Class = null;
         if(param1 == this._info)
         {
            return;
         }
         _loc2_ = false;
         if(this._info && param1)
         {
            _loc2_ = this._info.ID == param1.ID && this._info.GameAssetUrl == param1.GameAssetUrl;
         }
         if(!_loc2_ && this._loader && this._loader.isLoading)
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__onComplete);
         }
         this._info = param1;
         tipData = param1;
         if((!this._info || !_loc2_) && this._petMovie)
         {
            this._petMovie.removeEventListener(ActionMovieEvent.ACTION_END,this.doNextAction);
            this._petMovie.dispose();
            this._petMovie = null;
         }
         if(this._info)
         {
            if(this._info.IsEquip)
            {
               if(!this._fightImg)
               {
                  this._fightImg = ComponentFactory.Instance.creatBitmap("assets.petsBag.fight3");
                  addChild(this._fightImg);
               }
               this._fightImg.visible = true;
            }
            else if(this._fightImg)
            {
               this._fightImg.visible = false;
            }
            if(_loc2_)
            {
               return;
            }
            if(ModuleLoader.hasDefinition("pet.asset.game." + param1.GameAssetUrl))
            {
               _loc3_ = ModuleLoader.getDefinition("pet.asset.game." + param1.GameAssetUrl) as Class;
               this._petMovie = new _loc3_();
               this._petMovie.mute();
               this._petMovie.doAction(Helpers.randomPick(this.ACTIONS));
               this._petMovie.addEventListener(ActionMovieEvent.ACTION_END,this.doNextAction);
               addChild(this._petMovie);
            }
            else
            {
               this._loader = LoaderManager.Instance.creatLoader(PathManager.solvePetGameAssetUrl(param1.GameAssetUrl),BaseLoader.MODULE_LOADER);
               this._loader.addEventListener(LoaderEvent.COMPLETE,this.__onComplete);
               LoaderManager.Instance.startLoad(this._loader);
            }
         }
         else if(this._fightImg)
         {
            this._fightImg.visible = false;
         }
      }
      
      private function __onComplete(param1:LoaderEvent) : void
      {
         var _loc2_:Class = null;
         this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__onComplete);
         if(this._info && ModuleLoader.hasDefinition("pet.asset.game." + this._info.GameAssetUrl))
         {
            _loc2_ = ModuleLoader.getDefinition("pet.asset.game." + this._info.GameAssetUrl) as Class;
            this._petMovie = new _loc2_();
            this._petMovie.mute();
            this._petMovie.doAction(Helpers.randomPick(this.ACTIONS));
            this._petMovie.addEventListener(ActionMovieEvent.ACTION_END,this.doNextAction);
            addChild(this._petMovie);
         }
      }
      
      private function doNextAction(param1:ActionMovieEvent) : void
      {
         if(this._petMovie)
         {
            if(getTimer() - this._lastTime > 40)
            {
               this._petMovie.doAction(Helpers.randomPick(this.ACTIONS));
            }
            this._lastTime = getTimer();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._petMovie)
         {
            this._petMovie.removeEventListener(ActionMovieEvent.ACTION_END,this.doNextAction);
         }
         ObjectUtils.disposeObject(this._petMovie);
         this._petMovie = null;
         this._info = null;
         if(this._fightImg)
         {
            ObjectUtils.disposeObject(this._fightImg);
            this._fightImg = null;
         }
         if(this._loader)
         {
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__onComplete);
         }
         this._loader = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get fightImg() : Bitmap
      {
         return this._fightImg;
      }
   }
}
