module Cognituz::Search
  AREL_OPERATORS = %i[eq matches]

  def run(query, params = {})
    params = params.with_indifferent_access
    filters.inject(query) { |q, f| f.call(q, params) }.all
  end

  private

  def filter(
    name_or_hash,
    required_params: [name_or_hash],
    operator:        :eq,
    &block
  )
    return filters.push(block) if block_given?

    filter =
      case name_or_hash
      when Symbol
        if arel_operator?(operator)
          build_arel_filter(
            name_or_hash,
            required_params: required_params,
            operator:        operator
          )
        else
          send(
            :"def_#{operator}_filter",
            name_or_hash,
            required_params: required_params,
            operator:        operator
          )
        end
      when Hash
      end

    filters.push(filter)
  end

  def filters
    @filters ||= []
  end

  def arel_operator?(op)
    AREL_OPERATORS.include?(op)
  end

  def build_arel_filter(
    name,
    required_params: [name],
    operator:        :eq
  )
    -> (query, params) do
      operands = params.values_at(*required_params)
      return query unless operands.all?(&:present?)
      model = query.all.model
      query.where model.arel_table[name].send(operator, *operands)
    end
  end
end
