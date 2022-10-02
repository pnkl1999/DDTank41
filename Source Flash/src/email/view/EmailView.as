package email.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import email.data.EmailState;
   import email.manager.MailManager;
   import email.model.EmailModel;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class EmailView extends Sprite implements Disposeable
   {
       
      
      private var _controller:MailManager;
      
      private var _model:EmailModel;
      
      private var _read:ReadingView;
      
      private var _write:WritingView;
      
      public function EmailView()
      {
         super();
      }
      
      public function setup(controller:MailManager, model:EmailModel) : void
      {
         this._controller = controller;
         this._model = model;
         this.addEvent();
      }
      
      private function addEvent() : void
      {
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStage);
         this._model.addEventListener(EmailEvent.CHANE_STATE,this.__changeState);
         this._model.addEventListener(EmailEvent.CHANGE_TYPE,this.__changeType);
         this._model.addEventListener(EmailEvent.CHANE_PAGE,this.__changePage);
         this._model.addEventListener(EmailEvent.SELECT_EMAIL,this.__selectEmail);
         this._model.addEventListener(EmailEvent.REMOVE_EMAIL,this.__removeEmail);
         this._model.addEventListener(EmailEvent.INIT_EMAIL,this.__initEmail);
         addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
      }
      
      private function removeEvent() : void
      {
         this._model.removeEventListener(EmailEvent.CHANE_STATE,this.__changeState);
         this._model.removeEventListener(EmailEvent.CHANGE_TYPE,this.__changeType);
         this._model.removeEventListener(EmailEvent.CHANE_PAGE,this.__changePage);
         this._model.removeEventListener(EmailEvent.SELECT_EMAIL,this.__selectEmail);
         this._model.removeEventListener(EmailEvent.REMOVE_EMAIL,this.__removeEmail);
         this._model.removeEventListener(EmailEvent.INIT_EMAIL,this.__initEmail);
         removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
      }
      
      private function __keyDownHandler(evt:KeyboardEvent) : void
      {
         if(evt.keyCode == Keyboard.ESCAPE)
         {
            evt.stopImmediatePropagation();
            SoundManager.instance.play("008");
            this.dispatchEvent(new EmailEvent(EmailEvent.ESCAPE_KEY));
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._controller = null;
         this._model = null;
         if(this._read)
         {
            ObjectUtils.disposeObject(this._read);
         }
         this._read = null;
         if(this._write)
         {
            ObjectUtils.disposeObject(this._write);
         }
         this._write = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function resetWrite() : void
      {
         this._write.reset();
      }
      
      public function cancelMail() : void
      {
         this._read.setListView(this._model.getViewData(),this._model.totalPage,this._model.currentPage);
      }
      
      private function __addToStage(event:Event) : void
      {
         MailManager.Instance.changeState(EmailState.READ);
         MailManager.Instance.changeType(EmailState.ALL);
         MailManager.Instance.updateNoReadMails();
         if(this._model.isLoaded)
         {
            this._model.currentPage = 1;
         }
      }
      
      private function __changeType(event:EmailEvent) : void
      {
         this._read.switchBtnsVisible(this._model.mailType != EmailState.SENDED);
         this.updateListView();
      }
      
      private function __changeState(event:EmailEvent) : void
      {
         if(this._model.state == EmailState.READ)
         {
            if(this._read == null)
            {
               this._read = ComponentFactory.Instance.creat("email.readingView");
            }
            addChild(this._read);
            if(this._write && this._write.parent)
            {
               this._write.parent.removeChild(this._write);
            }
            if(stage && stage.focus)
            {
               stage.focus == this._read;
            }
            PositionUtils.setPos(this,"EmailView.Pos_0");
         }
         else
         {
            if(this._write == null)
            {
               this._write = ComponentFactory.Instance.creat("email.writingView");
            }
            PositionUtils.setPos(this,"EmailView.Pos_1");
            this._write.selectInfo = this._model.selectEmail;
            addChild(this._write);
            if(this._read && this._read.parent)
            {
               this._read.parent.removeChild(this._read);
            }
            if(stage && stage.focus)
            {
               stage.focus == this._write;
            }
            if(this._model.state == EmailState.WRITE)
            {
               this._write.reset();
            }
         }
      }
      
      private function __changePage(event:EmailEvent) : void
      {
         this.updateListView();
      }
      
      private function __selectEmail(event:EmailEvent) : void
      {
         this._read.info = event.info;
         if(event.info == null)
         {
            this._read.personalHide();
         }
         this._read.readOnly = false;
         if(this._model.mailType == EmailState.SENDED)
         {
            this._read.isCanReply = !!Boolean(null) ? Boolean(Boolean(Boolean(true))) : Boolean(Boolean(Boolean(false)));
            this._read.readOnly = true;
            return;
         }
         this._read.isCanReply = this._model.selectEmail && this._model.selectEmail.canReply ? Boolean(Boolean(Boolean(true))) : Boolean(Boolean(Boolean(false)));
      }
      
      private function __removeEmail(event:EmailEvent) : void
      {
         this.updateListView();
      }
      
      private function __initEmail(event:EmailEvent) : void
      {
         this.updateListView();
      }
      
      private function updateListView() : void
      {
         this._read.setListView(this._model.getViewData(),this._model.totalPage,this._model.currentPage,this._model.mailType == EmailState.SENDED);
      }
      
      public function get writeView() : WritingView
      {
         return this._write;
      }
   }
}
