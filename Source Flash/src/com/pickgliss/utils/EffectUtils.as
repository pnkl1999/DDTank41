package com.pickgliss.utils
{
   import com.pickgliss.effect.EffectColorType;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.filters.GradientGlowFilter;
   import flash.geom.ColorTransform;
   
   public class EffectUtils
   {
       
      
      public function EffectUtils()
      {
         super();
      }
      
      public static function imageGlower(param1:DisplayObject, param2:Number, param3:Number, param4:Number, param5:String) : void
      {
         var _loc8_:Array = null;
         if(param5 == EffectColorType.YELLOW)
         {
            _loc8_ = [16754176,16754176,16754176,16754176];
         }
         if(param5 == EffectColorType.GOLD)
         {
            _loc8_ = [6684672,16737792,16755200,16777164];
         }
         if(param5 == EffectColorType.BLUE)
         {
            _loc8_ = [13209,13209,39423,10079487];
         }
         if(param5 == EffectColorType.GREEN)
         {
            _loc8_ = [26112,3381504,10092288,16777164];
         }
         if(param5 == EffectColorType.OCEAN)
         {
            _loc8_ = [13107,3368550,10079436,13434879];
         }
         if(param5 == EffectColorType.AQUA)
         {
            _loc8_ = [13107,26214,52428,65535];
         }
         if(param5 == EffectColorType.ICE)
         {
            _loc8_ = [13158,3368601,6724044,10079487];
         }
         if(param5 == EffectColorType.SPARK)
         {
            _loc8_ = [102,26265,3394815,13434879];
         }
         if(param5 == EffectColorType.SILVER)
         {
            _loc8_ = [3355443,6710886,12303291,16777215];
         }
         if(param5 == EffectColorType.NEON)
         {
            _loc8_ = [3355596,6697932,10066431,13421823];
         }
         var _loc9_:Array = [0,1,1,1];
         var _loc10_:Array = [0,63,126,255];
         var _loc11_:Number = param3;
         var _loc12_:Number = param3;
         var _loc13_:Number = param2;
         param4 = param4;
         var _loc16_:GradientGlowFilter = new GradientGlowFilter(0,45,_loc8_,_loc9_,_loc10_,_loc11_,_loc12_,_loc13_,param4,"outer",false);
         var _loc17_:Array = new Array();
         _loc17_.push(_loc16_);
         param1.filters = _loc17_;
      }
      
      public static function imageShiner(param1:DisplayObject, param2:Number) : void
      {
         var _loc3_:ColorTransform = new ColorTransform();
         var _loc4_:Number = param2;
         _loc3_.redOffset = _loc4_;
         _loc3_.redMultiplier = _loc4_ / 100 + 1;
         _loc3_.greenOffset = _loc4_;
         _loc3_.greenMultiplier = _loc4_ / 100 + 1;
         _loc3_.blueOffset = _loc4_;
         _loc3_.blueMultiplier = _loc4_ / 100 + 1;
         param1.transform.colorTransform = _loc3_;
      }
      
      public static function creatMcToBitmap(param1:DisplayObject, param2:uint) : Bitmap
      {
         var _loc3_:BitmapData = new BitmapData(param1.width,param1.height,true,param2);
         _loc3_.draw(param1);
         return new Bitmap(_loc3_);
      }
      
      public static function toRadian(param1:Number) : Number
      {
         return Math.PI / 180 * param1;
      }
   }
}
