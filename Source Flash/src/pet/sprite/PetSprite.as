package pet.sprite
{
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.PathManager;
   import ddt.utils.PositionUtils;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import road.game.resource.ActionMovie;
   
   public class PetSprite extends Sprite
   {
      
      public static const APPEAR:String = "bornB";
      
      public static const DISAPPEAR:String = "outC";
      
      public static const HUNGER:String = "hunger";
       
      
      private var _petMovie:ActionMovie;
      
      private var _petModel:PetSpriteModel;
      
      private var _petController:PetSpriteController;
      
      private var _msgTxt:FilterFrameText;
      
      private var _msgBg:MovieClip;
      
      private var _loader:BaseLoader;
      
      private var _petSpriteLand:MovieClip;
      
      private var _petHeight:int = 0;
      
      private var _petWidth:int = 0;
      
      private var _petY:int = 0;
      
      private var _petX:int = 0;
      
      public function PetSprite(param1:PetSpriteModel, param2:PetSpriteController)
      {
         super();
         this._petModel = param1;
         this._petController = param2;
         this.initView();
         this.initLand();
      }
      
      private function initView() : void
      {
         this._msgBg = ComponentFactory.Instance.creatCustomObject("petSprite.ChatBall") as MovieClip;
         DisplayObject(this._msgBg["bg"]["rtTopPoint"]).alpha = 0;
         this._msgBg.visible = false;
         this._msgTxt = ComponentFactory.Instance.creatComponentByStylename("petSprite.MessageTxt");
         this._msgTxt.visible = false;
         addChild(this._msgBg);
         addChild(this._msgTxt);
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      public function playAnimation(param1:String, param2:Function = null) : void
      {
         if(this._petMovie)
         {
            this._petMovie.doAction(param1,param2);
         }
         else if(param2 != null)
         {
            param2();
         }
      }
      
      public function petMove() : void
      {
         if(this._petMovie)
         {
            removeEventListener(Event.ENTER_FRAME,this.petToMove);
            addEventListener(Event.ENTER_FRAME,this.petToMove);
         }
      }
      
      public function petNotMove() : void
      {
         if(this._petMovie)
         {
            removeEventListener(Event.ENTER_FRAME,this.petToMove);
         }
      }
      
      private function petToMove(param1:Event) : void
      {
         if(!this._petMovie)
         {
            removeEventListener(Event.ENTER_FRAME,this.petToMove);
            return;
         }
         if(this._petMovie.scaleX == 1)
         {
            --this._petMovie.x;
            --this._msgBg.x;
            --this._msgTxt.x;
            if(this._petMovie.x <= -25)
            {
               this._petMovie.scaleX = -1;
            }
         }
         else if(this._petMovie.scaleX == -1)
         {
            ++this._petMovie.x;
            ++this._msgBg.x;
            ++this._msgTxt.x;
            if(this._petMovie.x >= 100)
            {
               this._petMovie.scaleX = 1;
            }
         }
      }
      
      public function say(param1:String) : void
      {
         this._msgTxt.text = param1;
         this._msgTxt.visible = true;
         this._msgBg.visible = true;
         this.updateSize();
      }
      
      private function updateSize() : void
      {
         if(this._msgTxt.textWidth > this._msgBg.width)
         {
            this._msgBg.width = this._msgTxt.textWidth;
         }
         if(this._msgTxt.textHeight > this._msgBg.height)
         {
            this._msgBg.height = this._msgTxt.textHeight;
         }
         if(!this._petMovie)
         {
            return;
         }
         if(this._petModel.currentPet.actionMovieName == "pet.asset.game.pet030")
         {
            this._msgBg.y = this._petMovie.y - this._petHeight + 60;
         }
         else if(this._petModel.currentPet.actionMovieName == "pet.asset.game.pet029")
         {
            this._msgBg.y = this._petMovie.y - this._petHeight - 20;
         }
         else
         {
            this._msgBg.y = this._petHeight > 100 ? Number(Number(this._petMovie.y - this._petHeight + 40)) : Number(Number(this._petMovie.y - this._petHeight - 10));
         }
         this._msgBg.x = this._petMovie.x + 20;
         this._msgTxt.y = this._msgBg.y - 80;
         this._msgTxt.x = this._msgBg.x - 65;
      }
      
      public function hideMessageText() : void
      {
         this._msgTxt.visible = false;
         this._msgBg.visible = false;
      }
      
      public function updatePet() : void
      {
         this.initLand();
         this.initMovie();
      }
      
      private function initLand() : void
      {
         if(!this._petModel.petSwitcher)
         {
            return;
         }
         if(!this._petSpriteLand)
         {
            this._petSpriteLand = ComponentFactory.Instance.creat("asset.chat.petSprite.land");
         }
         PositionUtils.setPos(this._petSpriteLand,"chat.petSprite.landPos");
      }
      
      private function initMovie() : void
      {
         var _loc1_:Class = null;
         if(this._petMovie)
         {
            removeEventListener(Event.ENTER_FRAME,this.petToMove);
            removeChild(this._petMovie);
            this._petMovie = null;
         }
         if(!this._petModel.currentPet)
         {
            return;
         }
         if(this._petModel.currentPet.assetReady)
         {
            _loc1_ = ModuleLoader.getDefinition(this._petModel.currentPet.actionMovieName) as Class;
            this._petMovie = new _loc1_();
            PositionUtils.setPos(this._petMovie,"petSprite.PetMoviePos");
            addChild(this._petMovie);
            this._petHeight = this._petMovie.height;
            this._petWidth = this._petMovie.width;
         }
         else
         {
            this._loader = LoaderManager.Instance.creatLoader(PathManager.solvePetGameAssetUrl(this._petModel.currentPet.GameAssetUrl),BaseLoader.MODULE_LOADER);
            this._loader.addEventListener(LoaderEvent.COMPLETE,this.__onComplete);
            LoaderManager.Instance.startLoad(this._loader);
         }
      }
      
      protected function __onComplete(param1:LoaderEvent) : void
      {
         if(this._petMovie)
         {
            ObjectUtils.disposeObject(this._petMovie);
            this._petMovie = null;
         }
         this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__onComplete);
         var _loc2_:Class = ModuleLoader.getDefinition(this._petModel.currentPet.actionMovieName) as Class;
         this._petMovie = new _loc2_();
         PositionUtils.setPos(this._petMovie,"petSprite.PetMoviePos");
         addChild(this._petMovie);
         this._petHeight = this._petMovie.height;
         this._petWidth = this._petMovie.width;
      }
      
      public function get petSpriteLand() : MovieClip
      {
         return this._petSpriteLand;
      }
      
      public function set petSpriteLand(param1:MovieClip) : void
      {
         this._petSpriteLand = param1;
      }
   }
}
