package com.pickgliss.ui.core
{
   import com.pickgliss.ui.ShowTipManager;
   
   public class TransformableComponent extends Component implements ITransformableTipedDisplay
   {
      
      public static const P_tipWidth:String = "tipWidth";
      
      public static const P_tipHeight:String = "tipHeight";
       
      
      protected var _tipWidth:int;
      
      protected var _tipHeight:int;
      
      public function TransformableComponent()
      {
         super();
      }
      
      public function get tipWidth() : int
      {
         return this._tipWidth;
      }
      
      public function set tipWidth(param1:int) : void
      {
         if(this._tipWidth == param1)
         {
            return;
         }
         this._tipWidth = param1;
         onPropertiesChanged(P_tipWidth);
      }
      
      public function get tipHeight() : int
      {
         return this._tipHeight;
      }
      
      public function set tipHeight(param1:int) : void
      {
         if(this._tipHeight == param1)
         {
            return;
         }
         this._tipHeight = param1;
         onPropertiesChanged(P_tipHeight);
      }
      
      override protected function onProppertiesUpdate() : void
      {
         if(_changedPropeties[P_tipWidth] || _changedPropeties[P_tipHeight] || _changedPropeties[P_tipDirction] || _changedPropeties[P_tipGap] || _changedPropeties[P_tipStyle] || _changedPropeties[P_tipData])
         {
            ShowTipManager.Instance.addTip(this);
         }
      }
   }
}
