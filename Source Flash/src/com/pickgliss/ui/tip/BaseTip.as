package com.pickgliss.ui.tip
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.utils.ObjectUtils;
   
   public class BaseTip extends Component implements ITip
   {
      
      public static const P_tipbackgound:String = "tipbackgound";
       
      
      protected var _tipbackgound:Image;
      
      protected var _tipbackgoundstyle:String;
      
      public function BaseTip()
      {
         super();
         mouseChildren = false;
         mouseEnabled = false;
      }
      
      override public function dispose() : void
      {
         if(this._tipbackgound)
         {
            ObjectUtils.disposeObject(this._tipbackgound);
         }
         this._tipbackgound = null;
         super.dispose();
      }
      
      public function set tipbackgound(param1:Image) : void
      {
         if(this._tipbackgound == param1)
         {
            return;
         }
         ObjectUtils.disposeObject(this._tipbackgound);
         this._tipbackgound = param1;
         onPropertiesChanged(P_tipbackgound);
      }
      
      public function set tipbackgoundstyle(param1:String) : void
      {
         if(this._tipbackgoundstyle == param1)
         {
            return;
         }
         this._tipbackgoundstyle = param1;
         this.tipbackgound = ComponentFactory.Instance.creat(this._tipbackgoundstyle);
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(this._tipbackgound)
         {
            addChild(this._tipbackgound);
         }
      }
   }
}
