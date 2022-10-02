package game.objects
{
   import com.pickgliss.loader.ModuleLoader;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   import pet.date.PetInfo;
   import road.game.resource.ActionMovie;
   
   public class GamePetMovie extends Sprite implements Disposeable
   {
      
      public static const PlayEffect:String = "PlayEffect";
       
      
      private var _petInfo:PetInfo;
      
      private var _player:GamePlayer;
      
      private var _petMovie:ActionMovie;
      
      public function GamePetMovie(param1:PetInfo, param2:GamePlayer)
      {
         super();
         this._petInfo = param1;
         this._player = param2;
         this.init();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         if(this._petMovie)
         {
            this._petMovie.addEventListener("effect",this.__playPlayerEffect);
         }
      }
      
      protected function __playPlayerEffect(param1:Event) : void
      {
         dispatchEvent(new Event(PlayEffect));
      }
      
      public function init() : void
      {
         var _loc1_:Class = null;
         if(this._petInfo.assetReady)
         {
            _loc1_ = ModuleLoader.getDefinition(this._petInfo.actionMovieName) as Class;
            this._petMovie = new _loc1_();
            addChild(this._petMovie);
         }
      }
      
      public function show(param1:int = 0, param2:int = 0) : void
      {
         this._player.map.addToPhyLayer(this);
         PositionUtils.setPos(this,new Point(param1,param2));
      }
      
      public function hide() : void
      {
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
      
      public function get info() : PetInfo
      {
         return this._petInfo;
      }
      
      public function set direction(param1:int) : void
      {
         if(this._petMovie)
         {
            this._petMovie.scaleX = -param1;
         }
      }
      
      public function doAction(param1:String, param2:Function = null, param3:Array = null) : void
      {
         if(this._petMovie)
         {
            this._petMovie.doAction(param1,param2,param3);
         }
      }
      
      public function dispose() : void
      {
         if(this._petMovie)
         {
            this._petMovie.removeEventListener("effect",this.__playPlayerEffect);
         }
         ObjectUtils.disposeObject(this._petMovie);
         this._petMovie = null;
      }
   }
}
