package trainer.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   
   public class Question extends Frame
   {
       
      
      protected var imgTxtBg:ScaleBitmapImage;
      
      protected var txtTitle:FilterFrameText;
      
      protected var txtTip:FilterFrameText;
      
      protected var txtAward:FilterFrameText;
      
      protected var vbox:VBox;
      
      private var _imgBg:ScaleBitmapImage;
      
      public function Question()
      {
         super();
         this.initView();
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._imgBg = null;
         this.imgTxtBg = null;
         this.txtTip = null;
         this.txtAward = null;
         this.txtTitle = null;
         this.vbox = null;
         super.dispose();
      }
      
      private function initView() : void
      {
         this._imgBg = ComponentFactory.Instance.creat("trainer.question.bg");
         addToContent(this._imgBg);
         this.imgTxtBg = ComponentFactory.Instance.creat("trainer.question.txtBg");
         addToContent(this.imgTxtBg);
         this.txtTip = ComponentFactory.Instance.creat("trainer.question.tip");
         addToContent(this.txtTip);
         this.txtAward = ComponentFactory.Instance.creat("trainer.question.award");
         addToContent(this.txtAward);
         this.txtTitle = ComponentFactory.Instance.creat("trainer.question.title");
         addToContent(this.txtTitle);
         this.vbox = ComponentFactory.Instance.creat("trainer.question.vbox");
         addToContent(this.vbox);
      }
   }
}
