package store.view.embed
{
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.ITransformableTipedDisplay;
   
   public class MultipleButton extends BaseButton implements ITransformableTipedDisplay
   {
       
      
      public var P_tipWidth:String = "tipWidth";
      
      public var P_tipHeight:String = "tipHeight";
      
      protected var _tipWidth:int;
      
      protected var _tipHeight:int;
      
      public function MultipleButton()
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
         onPropertiesChanged(this.P_tipWidth);
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
         onPropertiesChanged(this.P_tipHeight);
      }
      
      override protected function onProppertiesUpdate() : void
      {
         if(_changedPropeties[P_tipDirction] || _changedPropeties[P_tipGap] || _changedPropeties[P_tipStyle] || _changedPropeties[P_tipData] || _changedPropeties[this.P_tipWidth] || _changedPropeties[this.P_tipHeight])
         {
            ShowTipManager.Instance.addTip(this);
         }
      }
   }
}
