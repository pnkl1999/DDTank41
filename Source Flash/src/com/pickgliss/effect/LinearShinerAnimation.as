package com.pickgliss.effect
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Sine;
   import flash.display.DisplayObjectContainer;
   
   public class LinearShinerAnimation extends AlphaShinerAnimation
   {
       
      
      public function LinearShinerAnimation(param1:int)
      {
         super(param1);
      }
      
      override public function play() : void
      {
         if(TweenMax.isTweening(_maskShape))
         {
            return;
         }
         DisplayObjectContainer(target).addChildAt(_shineAnimationContainer,0);
         if(_isLoop)
         {
            TweenMax.to(_maskShape,_shineMoveSpeed,{
               "startAt":{"alpha":0},
               "alpha":1,
               "yoyo":true,
               "repeat":-1,
               "ease":Sine.easeOut
            });
         }
         else
         {
            TweenMax.to(_maskShape,_shineMoveSpeed,{
               "startAt":{"alpha":0},
               "alpha":1,
               "ease":Sine.easeOut
            });
         }
      }
   }
}
