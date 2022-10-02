package civil.view
{
   import civil.CivilController;
   import civil.CivilModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class CivilView extends Sprite implements Disposeable
   {
       
      
      private var _civilLeftView:CivilLeftView;
      
      private var _civilRightView:CivilRightView;
      
      private var _controller:CivilController;
      
      private var _model:CivilModel;
      
      private var _chatFrame:Sprite;
      
      private var _title:Bitmap;
      
      public function CivilView(param1:CivilController, param2:CivilModel)
      {
         super();
         this._controller = param1;
         this._model = param2;
         this.init();
      }
      
      private function init() : void
      {
         this._civilLeftView = new CivilLeftView(this._controller,this._model);
         this._civilRightView = new CivilRightView(this._controller,this._model);
         ChatManager.Instance.state = ChatManager.CHAT_CIVIL_VIEW;
         this._chatFrame = ChatManager.Instance.view;
         addChild(this._civilLeftView);
         addChild(this._civilRightView);
         addChild(this._chatFrame);
         this._title = ComponentFactory.Instance.creatBitmap("asset.civil.titleAseet");
         addChild(this._title);
      }
      
      public function dispose() : void
      {
         if(this._civilLeftView)
         {
            ObjectUtils.disposeObject(this._civilLeftView);
            this._civilLeftView = null;
         }
         if(this._civilRightView)
         {
            ObjectUtils.disposeObject(this._civilRightView);
            this._civilRightView = null;
         }
         if(this._title)
         {
            ObjectUtils.disposeObject(this._title);
            this._title = null;
         }
         this._chatFrame = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
