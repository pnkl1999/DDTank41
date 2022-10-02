package times.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   import times.TimesController;
   import times.utils.TimesUtils;
   
   public class TimesDateView extends Sprite implements Disposeable
   {
       
      
      private var _controller:TimesController;
      
      private var _currentDate:Date;
      
      private var _nextEditionDate:Date;
      
      private var _currentDateTxt:FilterFrameText;
      
      private var _nextEditionDateTxt:FilterFrameText;
      
      private var _currentEditionTxt:FilterFrameText;
      
      private var _nextDateText:String;
      
      public function TimesDateView()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._controller = TimesController.Instance;
         this._currentDate = new Date();
         if(this._currentDate.getMonth() == 11)
         {
            this._nextEditionDate = new Date(this._currentDate.getFullYear() + 1,0,1);
         }
         else
         {
            this._nextEditionDate = new Date(this._currentDate.getFullYear(),this._currentDate.getMonth() + 1,1);
         }
         this._currentDateTxt = ComponentFactory.Instance.creatComponentByStylename("times.NormalText");
         this._nextEditionDateTxt = ComponentFactory.Instance.creatComponentByStylename("times.NormalText");
         this._currentEditionTxt = ComponentFactory.Instance.creatComponentByStylename("times.NormalText");
         this._currentDateTxt.text = TimesUtils.getWords("times.CurrentDateText",this._currentDate.getFullYear(),this.formatDate(this._currentDate.getMonth() + 1),this.formatDate(this._currentDate.getDate()));
         if(this._controller.model.nextDate != "")
         {
            this._nextDateText = String(this._controller.model.nextDate);
            this._nextEditionDateTxt.text = TimesUtils.getWords("times.NextEditionDateText",this._nextDateText.substr(0,4),this._nextDateText.substr(4,2),this._nextDateText.substr(6,2));
         }
         else
         {
            this._nextEditionDateTxt.text = TimesUtils.getWords("times.NextEditionDateText",this._nextEditionDate.getFullYear(),this.formatDate(this._nextEditionDate.getMonth() + 1),this.formatDate(this._nextEditionDate.getDate()));
         }
         this._currentEditionTxt.text = TimesUtils.getWords("times.CurrentEditionText",this.formatEdition(this._controller.model.edition));
         TimesUtils.setPos(this._currentDateTxt,"times.DateViewCurrentDateTextPos");
         TimesUtils.setPos(this._nextEditionDateTxt,"times.DateViewNextEditionDateTextPos");
         TimesUtils.setPos(this._currentEditionTxt,"times.DateViewCurrentEditionTextPos");
         this._currentDateTxt.mouseEnabled = this._nextEditionDateTxt.mouseEnabled = this._currentEditionTxt.mouseEnabled = false;
         addChild(this._currentDateTxt);
         addChild(this._nextEditionDateTxt);
         addChild(this._currentEditionTxt);
      }
      
      private function formatEdition(param1:int) : String
      {
         if(param1 > 99)
         {
            return String(param1);
         }
         if(param1 > 9)
         {
            return "0" + String(param1);
         }
         return "00" + String(param1);
      }
      
      private function formatDate(param1:Number) : String
      {
         if(param1 > 9)
         {
            return String(param1);
         }
         return "0" + String(param1);
      }
      
      public function dispose() : void
      {
         this._controller = null;
         ObjectUtils.disposeObject(this._currentDateTxt);
         this._currentDateTxt = null;
         ObjectUtils.disposeObject(this._nextEditionDateTxt);
         this._nextEditionDateTxt = null;
         ObjectUtils.disposeObject(this._currentEditionTxt);
         this._currentEditionTxt = null;
         this._currentDate = null;
         this._nextEditionDate = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
