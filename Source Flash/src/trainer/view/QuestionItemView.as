package trainer.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class QuestionItemView extends Sprite implements Disposeable
   {
       
      
      private var _bmpSel:Bitmap;
      
      private var _imgIcon:ScaleFrameImage;
      
      private var _txtContext:FilterFrameText;
      
      private var _index:int;
      
      private var _filters:Vector.<Array>;
      
      public function QuestionItemView()
      {
         super();
         this.initView();
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function setData(param1:int, param2:String) : void
      {
         this._index = param1;
         this._imgIcon.setFrame(this._index);
         this._txtContext.text = param2;
      }
      
      private function initView() : void
      {
         mouseChildren = false;
         buttonMode = true;
         addEventListener(MouseEvent.ROLL_OVER,this.__mouseHandler);
         addEventListener(MouseEvent.ROLL_OUT,this.__mouseHandler);
         addEventListener(MouseEvent.MOUSE_DOWN,this.__mouseHandler);
         addEventListener(MouseEvent.MOUSE_UP,this.__mouseHandler);
         this._filters = new Vector.<Array>();
         this._filters.push([ComponentFactory.Instance.model.getSet("lightFilter")]);
         this._filters.push([ComponentFactory.Instance.model.getSet("trainer.question.redFilter")]);
         this._bmpSel = ComponentFactory.Instance.creatBitmap("asset.trainer.question.sel");
         addChild(this._bmpSel);
         this._imgIcon = ComponentFactory.Instance.creat("trainer.question.icon");
         addChild(this._imgIcon);
         this._txtContext = ComponentFactory.Instance.creat("trainer.question.context");
         addChild(this._txtContext);
      }
      
      private function __mouseHandler(param1:MouseEvent) : void
      {
         switch(param1.type)
         {
            case MouseEvent.ROLL_OVER:
            case MouseEvent.MOUSE_UP:
               filters = this._filters[0];
               break;
            case MouseEvent.MOUSE_DOWN:
               filters = this._filters[1];
               break;
            case MouseEvent.ROLL_OUT:
               filters = null;
         }
      }
      
      public function dispose() : void
      {
         removeEventListener(MouseEvent.ROLL_OVER,this.__mouseHandler);
         removeEventListener(MouseEvent.ROLL_OUT,this.__mouseHandler);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.__mouseHandler);
         removeEventListener(MouseEvent.MOUSE_UP,this.__mouseHandler);
         ObjectUtils.disposeAllChildren(this);
         this._bmpSel = null;
         this._imgIcon = null;
         this._txtContext = null;
         this._filters = null;
         filters = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
