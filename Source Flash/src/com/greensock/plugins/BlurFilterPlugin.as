package com.greensock.plugins
{
   import com.greensock.TweenLite;
   import flash.filters.BlurFilter;
   
   public class BlurFilterPlugin extends FilterPlugin
   {
      
      public static const API:Number = 1;
      
      private static var _propNames:Array = ["blurX","blurY","quality"];
       
      
      public function BlurFilterPlugin()
      {
         super();
         this.propName = "blurFilter";
         this.overwriteProps = ["blurFilter"];
      }
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         _target = param1;
         _type = BlurFilter;
         initFilter(param2,new BlurFilter(0,0,int(int(param2.quality)) || int(int(2))),_propNames);
         return true;
      }
   }
}
