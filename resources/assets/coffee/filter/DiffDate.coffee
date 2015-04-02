
mainControllers.filter 'DiffDate', ->
  return (input) ->

    # 前置き

    if not input
        return ''

    if input.length isnt 10
        return ''

    dates = input.split("-");
    if dates.length isnt 3
        return ''

    date = parseInt(dates.join(""))
    if not date
        return ''

    if dates[0] > 2099
        return ''
    if dates[1] > 12 || dates[1] is "00"
        return ''
    if dates[2] > 31 || dates[2] is "00"
        return

    # 本処理

    date = new Date(dates[0], dates[1] - 1, dates[2])
    now = new Date()
    now = new Date(now.getFullYear(), now.getMonth(), now.getDate())

    diff_date = new Date(now.getFullYear(), date.getMonth(), date.getDate())
    if now > diff_date
        diff_date = new Date(now.getFullYear() + 1, date.getMonth(), date.getDate())

    diff = diff_date - now;
    diffDay = diff / 86400000
    return diffDay
