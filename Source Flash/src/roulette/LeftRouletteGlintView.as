package roulette
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class LeftRouletteGlintView extends Sprite implements Disposeable
   {
       
      
      private var _pointArray:Array;
      
      private var _glintSp:MovieClip;
      
      public function LeftRouletteGlintView(param1:Array)
      {
         super();
         this.init();
         this._pointArray = param1;
      }
      
      private function init() : void
      {
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      public function showThreeCell(param1:int) : void
      {
         var _loc2_:Array = new Array(0,60,120,180,240,300);
         if(param1 >= 0 && param1 <= 5)
         {
            if(this._glintSp == null)
            {
               this._glintSp = ComponentFactory.Instance.creat("asset.roulette.GlintAsset");
               addChild(this._glintSp);
            }
            this._glintSp.gotoAndPlay(1);
            this._glintSp.x = this._pointArray[param1].x;
            this._glintSp.y = this._pointArray[param1].y;
            this._glintSp.rotation = _loc2_[param1];
            this._glintSp.visible = true;
         }
      }
      
      public function stopGlint() : void
      {
         if(this._glintSp)
         {
            this._glintSp.gotoAndStop(1);
            this._glintSp.visible = false;
         }
      }
      
      public function dispose() : void
      {
         if(this._glintSp)
         {
            removeChild(this._glintSp);
         }
         this._glintSp = null;
      }
   }
}
