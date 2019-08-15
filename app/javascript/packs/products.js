import Vue from 'vue/dist/vue.esm'
import TurbolinksAdapter from 'vue-turbolinks'
import VueResource from 'vue-resource'

Vue.use(VueResource)
Vue.use(TurbolinksAdapter)

document.addEventListener('turbolinks:load', () => {
  Vue.http.headers.common['X-CSRF-Token'] = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

  let element = document.getElementById("products")
  if (element == null)
    return false
  let app = new Vue({
    el: element,
    data: {
      products: {},
      product: {},
      categories: [],
      search: {
        min_price: 0,
        max_price: 0
      },
      sort: {
        price: 'asc'
      },
      total_pages: 1,
      page: 1
  },
    methods: {
      show: function(id) {
        let that = this
        this.$http.get('/products/' + id).then(response => {
          that.product = response.body
        });
      },
      filter: function(isPaginate = false) {
        let q = this.prepareSearchParams()
        this.preparePageParams(isPaginate)
        let that = this
        this.$http.get('/products', { params: { q: q, sort: this.sort, page: this.page }}).then(response => {
          that.products = response.body.products;
          that.total_pages = response.body.search.total_pages;
        });
      },
      nextPage: function() {
        if(this.page != this.total_pages) {
          this.page += 1
          this.filter()
        }
      },
      prevPage: function() {
        if(this.page != 1) {
          this.page -= 1
          this.filter()
        }
      },
      prepareSearchParams: function() {
        let checked_categories = this.categories.filter(function(category) { return category.checked  })
                                                .map(function(category)    { return category.category })
        let q = checked_categories.length > 0 ? { category_in: checked_categories } : {}
        q.price_gteq = this.search.min_price
        q.price_lteq = this.search.max_price
        return q
      },
      preparePageParams: function(isPaginate) {
        if(isPaginate) { this.page = 1 }
      }
    },
    watch: {
      'search.max_price': function() { this.filter(true) },
      'search.min_price': function() { this.filter(true) },
      'sort.price':       function() { this.filter() },
    },
    mounted: function() {
      let that = this;
      this.$http.get('/products', { params: { sort: this.sort, page: this.page }}).then(response => {
        that.products    = response.body.products;
        that.categories  = response.body.search.categories.map(function(category) {
          return { category: category, checked: false }
        });
        that.search.max_price = response.body.search.max_price;
        that.total_pages      = response.body.search.total_pages;
      });
      this.max_price = 1
    },
  })
})