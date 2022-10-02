package calendar.view
{
   import activeEvents.data.ActiveEventsInfo;
   import com.pickgliss.geom.IntPoint;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class ActivityContentHolder extends Sprite implements Disposeable
   {
       
      
      private var _back:DisplayObject;
      
      private var _contentArea:TextArea;
      
      public function ActivityContentHolder()
      {
         super();
         this.configUI();
      }
      
      private function configUI() : void
      {
         this._back = ComponentFactory.Instance.creatComponentByStylename("Calendar.Activity.ContentBack");
         addChild(this._back);
         this._contentArea = ComponentFactory.Instance.creatComponentByStylename("Calendar.Activity.ContentArea");
         addChild(this._contentArea);
      }
      
      override public function get height() : Number
      {
         return this._back.height;
      }
      
      public function setContent(param1:ActiveEventsInfo) : void
      {
         this._contentArea.text = param1.Content;
         this._contentArea.viewPort.viewPosition = new IntPoint(0,0);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         ObjectUtils.disposeObject(this._contentArea);
         this._contentArea = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
