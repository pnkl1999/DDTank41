package fightLib.view
{
   import com.pickgliss.effect.AddMovieEffect;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.geom.Point;
   
   public class LevelButton extends BaseButton
   {
       
      
      private var _shineEffect:IEffect;
      
      private var _shine:Boolean = false;
      
      private var _selected:Boolean = false;
      
      private var _selectedBitmap:Bitmap;
      
      public function LevelButton()
      {
         super();
      }
      
      private static function createShineEffect(param1:LevelButton) : IEffect
      {
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("fightLib.Lessons.LevelShinePosition");
         return EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,param1,"fightLib.Lessons.LevelShine",_loc2_);
      }
      
      override protected function init() : void
      {
         super.init();
         this._shineEffect = createShineEffect(this);
         this._selectedBitmap = ComponentFactory.Instance.creatBitmap("fightLib.Lessons.hardness.Selected");
         addChildAt(this._selectedBitmap,0);
         this.enable = false;
      }
      
      override public function dispose() : void
      {
         if(this._selectedBitmap)
         {
            ObjectUtils.disposeObject(this._selectedBitmap);
            this._selectedBitmap = null;
         }
         if(this._shineEffect)
         {
            EffectManager.Instance.removeEffect(this._shineEffect);
            this._shineEffect = null;
         }
         super.dispose();
      }
      
      override public function set enable(param1:Boolean) : void
      {
         if(_enable != param1)
         {
            super.enable = param1;
            if(_enable)
            {
               this.filters = null;
            }
            else
            {
               this.filters = [ComponentFactory.Instance.model.getSet("fightLib.Lessons.GrayFilter")];
            }
            if(this._shine)
            {
               this.shine = false;
            }
            if(this._selected)
            {
               this.selected = false;
            }
         }
      }
      
      public function get shine() : Boolean
      {
         return this._shine;
      }
      
      public function set shine(param1:Boolean) : void
      {
         var _loc2_:DisplayObject = null;
         if(this._shine != param1)
         {
            this._shine = param1;
            if(this._shine)
            {
               if(_enable)
               {
                  this._shineEffect.play();
               }
            }
            else
            {
               this._shineEffect.stop();
               for each(_loc2_ in AddMovieEffect(this._shineEffect).movie)
               {
                  if(_loc2_ is MovieClip)
                  {
                     MovieClip(_loc2_).gotoAndStop(1);
                  }
               }
            }
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selected != param1)
         {
            this._selected = param1;
            this._selectedBitmap.visible = this._selected;
            this.setChildIndex(this._selectedBitmap,this.numChildren - 1);
         }
      }
   }
}
