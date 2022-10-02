package quest
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.quest.QuestInfo;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class QuestDescriptView extends Sprite implements Disposeable
   {
       
      
      private var _descTitle:Bitmap;
      
      private var descText:FilterFrameText;
      
      private var panel:ScrollPanel;
      
      private var container:Sprite;
      
      public function QuestDescriptView()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this.container = new Sprite();
         this._descTitle = ComponentFactory.Instance.creat("asset.core.quest.QuestInfoDescTitle");
         this.descText = ComponentFactory.Instance.creat("core.quest.QuestInfoDescription");
         this.panel = ComponentFactory.Instance.creatComponentByStylename("core.quest.QuestDescriptPanel");
         this.container.addChild(this._descTitle);
         this.container.addChild(this.descText);
         this.panel.setView(this.container);
         addChild(this.panel);
      }
      
      public function set info(param1:QuestInfo) : void
      {
         this.descText.htmlText = QuestDescTextAnalyz.start(param1.Detail);
         this.panel.invalidateViewport();
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._descTitle);
         this._descTitle = null;
         ObjectUtils.disposeObject(this.descText);
         this.descText = null;
         ObjectUtils.disposeObject(this.panel);
         this.panel = null;
         ObjectUtils.disposeObject(this.container);
         this.container = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
