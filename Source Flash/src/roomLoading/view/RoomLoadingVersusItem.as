package roomLoading.view
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Sine;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   
   public class RoomLoadingVersusItem extends Sprite implements Disposeable
   {
       
      
      private var _gameType:Bitmap;
      
      private var _versusMc:MovieClip;
      
      private var _hexagram:MovieClip;
      
      private var _gameMode:int;
      
      private var _glowFilter:GlowFilter;
      
      public function RoomLoadingVersusItem(param1:int)
      {
         super();
         this._gameMode = param1;
         this.init();
      }
      
      private function init() : void
      {
         this._glowFilter = new GlowFilter();
         this._hexagram = ComponentFactory.Instance.creat("asset.roomLoading.Hexagram");
         this._versusMc = ComponentFactory.Instance.creat("asset.roomLoading.VersusAnimation");
         PositionUtils.setPos(this._hexagram,"asset.roomLoading.HexagramPos");
         PositionUtils.setPos(this._versusMc,"asset.roomLoading.VersusAnimationPos");
         addChild(this._hexagram);
         addChild(this._versusMc);
         this.createGameModeTxt();
      }
      
      private function addEffect() : void
      {
         TweenMax.to(this._glowFilter,0.45,{
            "startAt":{
               "blurX":0,
               "blurY":0,
               "color":16763904,
               "strength":0
            },
            "blurX":5,
            "blurY":5,
            "color":16737792,
            "strength":0.6,
            "yoyo":true,
            "repeat":-1,
            "ease":Sine.easeOut,
            "onUpdate":this.updateFilter
         });
      }
      
      private function updateFilter() : void
      {
         this._gameType.filters = [this._glowFilter];
      }
      
      private function createGameModeTxt() : void
      {
         switch(this._gameMode)
         {
            case 0:
            case 4:
            case 9:
            case 11:
               this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_0");
               break;
            case 1:
               this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_1");
               break;
            case 2:
               this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_2");
               break;
            case 7:
            case 10:
               this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_7");
               break;
            case 8:
               this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_8");
               break;
            case 12:
            case 13:
               this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_12");
               break;
            case 15:
            case 16:
               this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_14");
               break;
            default:
               this._gameType = ComponentFactory.Instance.creatBitmap("asset.roomLoading.GameMode_0");
         }
         if(this._gameType)
         {
            addChild(this._gameType);
         }
      }
      
      public function dispose() : void
      {
         if(this._gameType)
         {
            TweenMax.killTweensOf(this._gameType);
         }
         if(this._glowFilter)
         {
            TweenMax.killTweensOf(this._glowFilter);
         }
         if(this._gameType)
         {
            this._gameType.filters = null;
         }
         ObjectUtils.disposeAllChildren(this);
         this._gameType = null;
         this._glowFilter = null;
         this._versusMc = null;
         this._hexagram = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
