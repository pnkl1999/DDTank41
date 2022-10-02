package quest
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.quest.QuestCondition;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class QuestConditionView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _cond:QuestCondition;
      
      private var conditionText:FilterFrameText;
      
      private var statusText:FilterFrameText;
      
      public function QuestConditionView(param1:QuestCondition)
      {
         super();
         this._bg = ComponentFactory.Instance.creat("asset.core.quest.QuestConditionBGHighlight");
         addChild(this._bg);
         this.conditionText = ComponentFactory.Instance.creat("core.quest.QuestConditionText");
         addChild(this.conditionText);
         this.statusText = ComponentFactory.Instance.creat("core.quest.QuestConditionStatus");
         addChild(this.statusText);
         this._cond = param1;
         this.text = this._cond.description;
      }
      
      public function set status(param1:String) : void
      {
         this.statusText.text = param1;
      }
      
      public function set text(param1:String) : void
      {
         this.conditionText.text = param1;
         if(this.conditionText.numLines > 1)
         {
            this.conditionText.y -= 3;
         }
         this.statusText.x = this.conditionText.x + this.conditionText.width - 15;
      }
      
      public function set isComplete(param1:Boolean) : void
      {
         if(param1 == true)
         {
         }
      }
      
      public function dispose() : void
      {
         this._cond = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this.conditionText)
         {
            ObjectUtils.disposeObject(this.conditionText);
         }
         this.conditionText = null;
         if(this.statusText)
         {
            ObjectUtils.disposeObject(this.statusText);
         }
         this.statusText = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
