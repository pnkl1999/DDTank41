package com.greensock.plugins
{
   import com.greensock.TweenLite;
   import flash.filters.GlowFilter;
   
   public class GlowFilterPlugin extends FilterPlugin
   {
      
      public static const API:Number = 1;
      
      private static var _propNames:Array = ["color","alpha","blurX","blurY","strength","quality","inner","knockout"];
       
      
      public function GlowFilterPlugin()
      {
         super();
         this.propName = "glowFilter";
         this.overwriteProps = ["glowFilter"];
      }
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         _target = param1;
         _type = GlowFilter;
         initFilter(param2,new GlowFilter(16777215,0,0,0,Number(Number(param2.strength)) || Number(Number(1)),int(int(param2.quality)) || int(int(2)),param2.inner,param2.knockout),_propNames);
         return true;
      }
   }
}
