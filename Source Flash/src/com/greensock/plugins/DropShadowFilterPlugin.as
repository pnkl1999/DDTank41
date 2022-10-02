package com.greensock.plugins
{
   import com.greensock.TweenLite;
   import flash.filters.DropShadowFilter;
   
   public class DropShadowFilterPlugin extends FilterPlugin
   {
      
      public static const API:Number = 1;
      
      private static var _propNames:Array = ["distance","angle","color","alpha","blurX","blurY","strength","quality","inner","knockout","hideObject"];
       
      
      public function DropShadowFilterPlugin()
      {
         super();
         this.propName = "dropShadowFilter";
         this.overwriteProps = ["dropShadowFilter"];
      }
      
      override public function onInitTween(param1:Object, param2:*, param3:TweenLite) : Boolean
      {
         _target = param1;
         _type = DropShadowFilter;
         initFilter(param2,new DropShadowFilter(0,45,0,0,0,0,1,int(int(param2.quality)) || int(int(2)),param2.inner,param2.knockout,param2.hideObject),_propNames);
         return true;
      }
   }
}
