describe('Navigation', () => {
  beforeEach(() => {
    cy.visit('/')
  })

  it('should display the home page', () => {
    cy.contains('LocaMat').should('be.visible')
    cy.contains('Gérez votre matériel').should('be.visible')
  })

  it('should navigate to about page', () => {
    cy.get('a').contains('À propos').click()
    cy.url().should('include', '/about')
    cy.contains('À propos de LocaMat').should('be.visible')
    cy.contains('Notre Mission').should('be.visible')
  })

  it('should navigate to contact page', () => {
    cy.get('a').contains('Contact').click()
    cy.url().should('include', '/contact')
    cy.contains('Contactez-nous').should('be.visible')
  })

  it('should have working navigation links in header', () => {
    cy.get('nav').within(() => {
      cy.get('a').should('have.length.gt', 2)
      cy.get('a').each(($el) => {
        cy.wrap($el).should('have.attr', 'href')
      })
    })
  })
})