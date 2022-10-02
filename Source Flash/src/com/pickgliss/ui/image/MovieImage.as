package com.pickgliss.ui.image
{
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ClassUtils;
   import flash.display.MovieClip;
   
   public class MovieImage extends Image
   {
       
      
      public function MovieImage()
      {
         super();
      }
      
      public function get movie() : MovieClip
      {
         return _display as MovieClip;
      }
      
      override public function setFrame(param1:int) : void
      {
         super.setFrame(param1);
         this.movie.gotoAndStop(param1);
         if(_width != Math.round(this.movie.width))
         {
            _width = Math.round(this.movie.width);
            _changedPropeties[Component.P_width] = true;
         }
      }
      
      override protected function resetDisplay() : void
      {
         if(_display)
         {
            removeChild(_display);
         }
         _display = ClassUtils.CreatInstance(_resourceLink);
      }
   }
}
