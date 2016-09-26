class AttachmentsController < ApplicationController
  
  def create
    @attachment = Attachment.new(attachment_params)
    @attachment.note_id = params[:note_id]
    @attachment.doc = params[:attachment][:doc]
    
    if @attachment.save then
      flash.now[t(:uploaded)]
      render :text => @attachment.to_json , :status => 200
    else
      flash.now[t(:error_on_upload)]
    end
     
  end
  
  def destroy
    @attachment = Attachment.find(params[:id])
    if @attachment.destroy then
      render :nothing => true, :status => 204
    end
    
  end
  
  private

    def attachment_params
      params.require(:attachment).permit(:note_id)
    end
    
end
