class ItemImporter
  include ActiveModel::Model

  attr_accessor :item_identifier, :binding_item_identifier,
    :shelf, :default_shelf,
    :call_number, :binding_call_number, :acquired_at,
    :price, :budget_type, :bookstore, :binded_at, :note, :include_supplements, :url,
    :dummy,
    :manifestation,
    :action, :record, :result, :error_message

  def import
    case action
    when 'create'
      create
    when 'update'
      update
    when 'destroy'
    else
      raise 'Invalid action'
    end
  end

  private

  def find_by_item_identifier
    Item.find_by(item_identifier: item_identifier.strip) if item_identifier
  end

  def create
    self.record = find_by_item_identifier
    if record
      self.result = :found
      return self
    end

    attributes = {
      manifestation: manifestation,
      shelf: Shelf.find_by(name: shelf) || Shelf.find_by(name: default_shelf) || Shelf.web,
      call_number: call_number,
      acquired_at: acquired_at,
      binding_call_number: binding_call_number,
      item_identifier: item_identifier,
      binding_item_identifier: binding_item_identifier,
      binded_at: binded_at,
      price: price,
      budget_type: BudgetType.find_by(name: budget_type),
      bookstore: Bookstore.find_by(name: bookstore),
      note: note,
      include_supplements: include_supplements,
      url: url
    }.compact
    item = Item.create(attributes)

    self.record = item
    if item&.valid?
      self.result = :created
    else
      self.error_message = item&.errors&.full_messages unless error_message
      self.result = :failed
    end

    self
  end

  def update
    self.record = find_by_item_identifier
    return unless record

    attributes = {
      shelf: Shelf.find_by(name: shelf),
      call_number: call_number,
      acquired_at: acquired_at,
      binding_call_number: binding_call_number,
      item_identifier: item_identifier,
      binding_item_identifier: binding_item_identifier,
      binded_at: binded_at,
      price: price,
      budget_type: BudgetType.find_by(name: budget_type),
      bookstore: Bookstore.find_by(name: bookstore),
      note: note,
      include_supplements: include_supplements,
      url: url
    }.compact
    record.update(attributes)

    if record.valid?
      self.result = :updated
    else
      self.result = :failed
    end

    self
  end

  def import_custom_item_property
  end
end
