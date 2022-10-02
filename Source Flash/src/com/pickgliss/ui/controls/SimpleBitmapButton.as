package com.pickgliss.ui.controls
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ComponentSetting;
   
   public class SimpleBitmapButton extends BaseButton
   {
       
      
      public function SimpleBitmapButton()
      {
         super();
         _frameFilter = ComponentFactory.Instance.creatFrameFilters(ComponentSetting.SIMPLE_BITMAP_BUTTON_FILTER);
      }
      
      override public function set backStyle(param1:String) : void
      {
         if(param1 == _backStyle)
         {
            return;
         }
         _backStyle = param1;
         backgound = ComponentFactory.Instance.creat(param1);
         _width = _back.width;
         _height = _back.height;
         onPropertiesChanged(P_backStyle);
      }
   }
}
